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
	import flash.events.NetStatusEvent;
	import flash.geom.Vector3D;
	import org.flixel.*;
	
	/**
	 * The Soldier will follow the leader, shooting anything that gets to close.
	 */
	public class Soldier extends Character
	{
		private var mBrain 		:StackFSM;	// Controls the FSM stuff
		private var mCaption 	:FlxText;	// a text field to show debug info
		
		public function Soldier(posX :Number, posY :Number, totalMass :Number) {
			super(posX, posY, totalMass);
			
			makeGraphic(25, 25, 0xff00ff00);
			addAnimation("walking",  [0, 1, 2, 3], 10);
			addAnimation("shooting", [4, 5], 15);
			play("walking");
			
			mBrain = new StackFSM();
			
			// Push the "follow" state so the soldier will follow the leader
			mBrain.pushState(follow);
			
			mCaption = new FlxText(0, 0, 60, "Happy :)");
			mCaption.color = 0x00ff00;
		}
		
		override public function think():void {
			// Update the brain. It will run the current state function.
			mBrain.update();
			
			// Update the animations
			if (mShooting <= 0 && _curAnim.name.indexOf("walking") == -1) {
				play("walking", true);
			}
		}
		
		/**
		 * The "follow" state.
		 * 
		 * It will make the soldier follow the leader, protecting him against the enemies.
		 * If a monster gets too close, the soldier will hunt it down.
		 */
		public function follow() :void {
			// If we're not shooting at something, follow the leader.
			var aLeader :Boid = Game.instance.boids[0];
			addSteeringForce(mBoid.followLeader(aLeader));
			
			// Is there a monster nearby?
			if (getNearestEnemy() != null) {
				// Yes, there is! Hunt it down!
				// Push the "hunt" state. It will make the soldier stop following the leader and
				// start hunting the monster.
				mBrain.pushState(hunt);
			}
			
			// Debug info
			mCaption.text  = "follow";
			mCaption.color = 0x00ff00; 
		}
		
		/**
		 * The "hunt" state.
		 * 
		 * It will make the soldier hunt down the nearest enemy. After the monster is killed,
		 * or after it leaves the hunting area, the state will be removed from the stack. 
		 */
		public function hunt() :void {
			// For now, let's just remove hunt() from the brain.
			mBrain.popState();
			
			// Debug info
			mCaption.text  = "hunt";
			mCaption.color = 0xffcc00; 
		}
		
		private function addSteeringForce(force :Vector3D) :void {
			 mBoid.steering = mBoid.steering.add(force);
		}
		
		private function getNearestEnemy() :Monster {
			return getNearestThing((FlxG.state as PlayState).monsters.members) as Monster;
		}
		
		/**
		 * Get the nearest thing from a group.
		 * 
		 * @param	theRadius the action radius
		 * @param	theGroup the group of things from which the method will select something.
		 * @return  the nearest thing in the group.
		 */
		private function getNearestThing(theGroup :Array, theRadius :Number = 150) :FlxSprite {
			var aNearestThing 		:FlxSprite = null;
			var aShortestDistance 	:Number = Number.MAX_VALUE;
			var aDistance			:Number;
			
			for (var i:int = 0; i < theGroup.length; i++) {
				if (theGroup[i] != null && theGroup[i].alive && theGroup[i].onScreen()) {
					
					aDistance = calculateDistance(theGroup[i], this);
					
					if(aDistance <= theRadius && aDistance < aShortestDistance) {
						aShortestDistance 	= aDistance;
						aNearestThing 		= theGroup[i];
					}
				}
			}
			
			return aNearestThing;
		}
		
		private function calculateDistance(a :FlxSprite, b :FlxSprite) :Number {
			return Math.sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y));
		}
		
		override protected function updateShootingAnimation():void {
			play("shooting", true);
		}
		
		override public function draw():void {
			super.draw();
			
			if((FlxG.state as PlayState).debug) {
				mCaption.x = x;
				mCaption.y = y - height;
				
				mCaption.draw();
			}
		}
	}
}