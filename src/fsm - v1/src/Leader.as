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
	 * The Leader class will wander around, usually following the mouse cursor.
	 */
	public class Leader extends Character
	{
		private var mMouse 	:Vector3D; // track the mouse cursor position
		
		public function Leader(posX :Number, posY :Number, totalMass :Number) {
			super(posX, posY, totalMass);
			
			makeGraphic(25, 25, 0xff0000ff);
			addAnimation("walking", 	[6, 7, 8, 9], 10);
			addAnimation("shooting", 	[10, 11], 15);
			play("walking");
			
			mMouse = new Vector3D();
		}
		
		override public function think():void {
			if (isShooting()) {
				// Change the velocity (direction) of the soldier to face the mouse pointer
				mBoid.velocity.x = FlxG.mouse.x - x;
				mBoid.velocity.y = FlxG.mouse.y - y;
				
				// Scale the velocity close to zero to ensure the soldier will face
				// the mouse pointer, but will remain still.
				mBoid.velocity.scaleBy(0.001);
				
			} else {
				// We are not shooting, so lets follow the mouse cursor.
				// Let's use the arrive() steering force for that.
				mMouse.x = FlxG.mouse.x;
				mMouse.y = FlxG.mouse.y;
				mBoid.steering = boid.steering.add(boid.arrive(mMouse, 50));
			}
			
			// Update the animations
			if (mShooting <= 0 && _curAnim.name.indexOf("walking") == -1) {
				play("walking", true);
			}
		}
		
		override protected function updateShootingAnimation():void {
			play("shooting", true);
		}
	}
}