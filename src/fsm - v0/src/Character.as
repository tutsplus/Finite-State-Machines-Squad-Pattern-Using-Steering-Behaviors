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
	
	public class Character extends FlxSprite
	{
		protected var mBoid 		:Boid; 		// used to control de steering behaviors stuff
		protected var mShootLag 	:Number;	// Controls the shooting stuff
		protected var mShooting 	:Number;
		
		public function Character(posX :Number, posY :Number, totalMass :Number) {
			super(posX, posY);
			
			mShootLag 	= Constants.SOLDIER_SHOOTING_LAG;
			mShooting 	= Constants.SOLDIER_SHOOTING_LAG;
			mBoid 		= new Boid(posX, posY, totalMass);
		}
		
		override public function update():void {
			super.update();
			
			// Counting if the solver is allowed to shoot again
			if(mShootLag > 0) {
				mShootLag -= FlxG.elapsed;
			}
			
			// Counting the shooting time
			if (mShooting > 0) {
				mShooting -= FlxG.elapsed;
			}
			
			// Clear all steering forces
			mBoid.steering.scaleBy(0);			

			// Every sub class should override the think() method and implement its
			// specific logic in it.
			think();
			
			// Update all steering stuff
			mBoid.update();
			
			// Update the Flixel sprite with boid info
			x = mBoid.x;
			y = mBoid.y;
			angle = mBoid.rotation;
		}
		
		/**
		 * Sub classes must override this method and implement specific behavior in it.
		 */ 
		public function think() :void {
		}
		
		public function shoot() :void {
			var aBullet :Bullet = (FlxG.state as PlayState).bullets.getFirstAvailable() as Bullet;
			
			if (aBullet != null && mShootLag <= 0) {
				aBullet.goFrom(this);
				mShootLag = Constants.SOLDIER_SHOOTING_LAG;
				mShooting = 0.7;
				
				updateShootingAnimation();
			}
		}
		
		/**
		 * Sub classes must implement this method, called every time the character fires the weapon.
		 */
		protected function updateShootingAnimation() :void {
		}
		
		/**
		 * Informs if the character is shooting at something.
		 */
		public function isShooting() :Boolean {
			return mShooting > 0;
		}
		
		public function get boid() :Boid { return mBoid; }
	}
}