package away3dlite.core.utils {
	
    import away3dlite.materials.*;
    
    import flash.display.*;
    import flash.geom.Matrix;
    import flash.utils.*;
    //import mx.core.BitmapAsset;

    /** Helper class for casting assets to usable objects */
    public class Cast
    {
        public static function string(data:*):String
        {
            if (data is Class)
                data = new data;

            if (data is String)
                return data;

            return String(data);
        }
    
        public static function bytearray(data:*):ByteArray
        {
            //throw new Error(typeof(data));

            if (data is Class)
                data = new data;

            if (data is ByteArray)
                return data;

            return ByteArray(data);
        }
    
        public static function xml(data:*):XML
        {
            if (data is Class)
                data = new data;

            if (data is XML)
                return data;

            return XML(data);
        }

        public static function bitmap(data:*):BitmapData
        {
            if (data == null)
                return null;

            if (data is String)
                data = tryclass(data);

            if (data is Class)
            {
                try
                {
                    data = new data;
                }
                catch (bitmaperror:ArgumentError)
                {
                    data = new data(0,0);
                }
            }

            if (data is BitmapData)
                return data;
			
			if (data is Bitmap)
            	if ((data as Bitmap).hasOwnProperty("bitmapData")) // if (data is BitmapAsset)
                	return (data as Bitmap).bitmapData;

            if (data is DisplayObject)
            {
                var ds:DisplayObject = data as DisplayObject;
                var bmd:BitmapData = new BitmapData(ds.width, ds.height, true, 0x00FFFFFF);
                var mat:Matrix = ds.transform.matrix.clone();
                mat.tx = 0;
                mat.ty = 0;
                bmd.draw(ds, mat, ds.transform.colorTransform, ds.blendMode, bmd.rect, true);
                return bmd;
            }

            throw new Error("Can't cast to bitmap: "+data);
        }

        private static var notclasses:Dictionary = new Dictionary();
        private static var classes:Dictionary = new Dictionary();

        public static function tryclass(name:String):Object
        {
            if (notclasses[name])
                return name;

            var result:Class = classes[name];

            if (result != null)
                return result;

            try
            {
                result = getDefinitionByName(name) as Class;
                classes[name] = result;
                return result;
            }
            catch (error:ReferenceError) {}

            notclasses[name] = true;
            return name;
        }

        public static function material(data:*):Material
        {
            if (data == null)
                return null;

            if (data is String)
                data = tryclass(data);

            if (data is Class)
            {
                try
                {
                    data = new data;
                }
                catch (materialerror:ArgumentError)
                {
                    data = new data(0,0);
                }
            }

            if (data is Material)
                return data;

            if (data is int) 
                return new ColorMaterial(data);

            //if (data is MovieClip) 
            //    return new MovieMaterial(data);

            if (data is String)
            {
                if (data == "")
                    return null;
            }

            try
            {
                var bmd:BitmapData = Cast.bitmap(data);
                return new BitmapMaterial(bmd);
            }
            catch (error:Error) {}

            throw new Error("Can't cast to material: "+data);
        }
    }
}
