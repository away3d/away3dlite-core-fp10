package away3dlite.containers
{
	import away3dlite.arcane;
	import away3dlite.core.base.Object3D;
	import away3dlite.core.base.Particle;
	
	import flash.display.Sprite;
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	use namespace arcane;
	
	/**
	 * Particles
	 * @author katopz
	 */
	public class Particles extends Object3D
	{
		private var _animated:Boolean;
		
		// linklist
		private var _firstParticle:Particle;
		private var _lastParticle:Particle;
		
		// still need array for sortOn
		public var lists:Array;
		
		// by pass
		private var _layer:Sprite;
		
		/** @private */
		arcane override function project(projectionMatrix3D:Matrix3D, parentSceneMatrix3D:Matrix3D = null):void
		{
			super.project(projectionMatrix3D, parentSceneMatrix3D);
			
			// by pass
			var Utils3D_projectVector:Function = Utils3D.projectVector;
			var _transform_matrix3D:Matrix3D = transform.matrix3D;
			var _position:Vector3D;
			var particle:Particle = _firstParticle;
			do{
				_position = Utils3D_projectVector(_transform_matrix3D, particle);
				particle.position = Utils3D_projectVector(_viewMatrix3D, _position);
				
				// layer dirty
				if(_layer!=layer)
					particle.layer = layer;
			}while(particle = particle.next);
			
			_layer = layer;
		}

		public function addParticle(particle:Particle):Particle
		{
			// add to lists
			if(!lists)
				lists = [];
			
			lists.push(particle);
			
			//link list
			if(!_firstParticle)
				_firstParticle = particle;
			
			if(_lastParticle)
				_lastParticle.next = particle;
			
			_lastParticle = particle;
			
			particle.animated = _animated;
			
			return particle;
		}
		
		public function set animated(value:Boolean):void
		{
			_animated = value;
			var particle:Particle = _firstParticle;
			do{
				particle.animated = _animated;
			}while(particle = particle.next);
		}
		
		public function Particles(animated:Boolean = false)
		{
			_animated = animated;
		}
	}
}