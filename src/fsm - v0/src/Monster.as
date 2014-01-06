/**
 * Copyright (c) 2013, Fernando Bevilacqua
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 * 
 *   Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * 
 *   Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or
 *   other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package  
{
	import flash.geom.Vector3D;
	import org.flixel.*;
	
	/**
	 * En ugly enemy. It will seek a random position in the screen. 
	 */
	public class Monster extends FlxSprite
	{
		private var mBoid 		:Boid;		// steering behavior stuff
		private var mTarget 	:Vector3D;	// the random target to seek
		
		public function Monster() {
			super( -10, -10);
			
			makeGraphic(25, 25, 0xffff0000);
			addAnimation("walking", 	[0, 1, 2, 3], 10);
			
			width  = 30;
			height = 20;
			offset.x = 30;
			offset.y = 10;
			
			play("walking");
			
			mTarget = new Vector3D();
			mBoid = new Boid( -10, -10, 10);
			kill();
		}
		
		public function spawn() :void {
			mTarget.x = 50 + FlxG.width * FlxG.random() * 0.8;
			mTarget.y = 50 + FlxG.height * FlxG.random() * 0.8;
			health 	= Constants.MONSTER_LIFE;
			
			boid.position.x = FlxG.width * FlxG.random();
			boid.position.y = FlxG.random() <= 0.5 ? (-50 * FlxG.random()) : (FlxG.height + 50 * FlxG.random());
			
			reset(boid.position.x, boid.position.y);
		}
		
		override public function update():void {
			super.update();
			
			// Clear any existing steering force
			mBoid.steering.scaleBy(0);
			
			// Add a new steering force to arrive at mTarget
			mBoid.steering = boid.steering.add(boid.arrive(mTarget, 20));
			mBoid.update();
			
			// Update Flixel sprite position and angle according to the boid info
			x = mBoid.x;
			y = mBoid.y;
			angle = mBoid.rotation;
		}
		
		override public function hurt(Damage:Number):void {
			if (!alive) return;
			
			super.hurt(Damage);
			
			if (!alive && FlxG.random() <= Constants.MONSTER_LOT_CHANCE) {
				dropLoot();
			}
		}
		
		private function dropLoot() :void {
			var aItem :Item = (FlxG.state as PlayState).items.getFirstAvailable() as Item;

			if (aItem != null) {
				aItem.respawn(x, y);
			}
		}
		
		public function get boid() :Boid { return mBoid; }
	}
}