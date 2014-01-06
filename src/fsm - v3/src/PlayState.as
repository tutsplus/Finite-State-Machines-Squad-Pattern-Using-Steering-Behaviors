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
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		private var mBullets			:FlxGroup;
		private var mSoldiers			:FlxGroup;
		private var mMonsters			:FlxGroup;
		private var mItems				:FlxGroup;
		private var mMonsterInterval	:Number;
		private var mDebug				:Boolean;
	
		override public function create():void {
			var i:int;
	
			mBullets 			= new FlxGroup(Constants.BULLET_MAX);
			mSoldiers 			= new FlxGroup(Constants.SOLDIER_MAX);
			mMonsters 			= new FlxGroup(Constants.MONSTER_MAX);
			mItems 				= new FlxGroup(Constants.ITEM_MAX);
			mMonsterInterval	= Constants.MONSTER_INTERVAL;
			mDebug				= true;
			
			// Add bullets to the screen
			for (i = 0; i < Constants.BULLET_MAX; i++) {
				mBullets.add(new Bullet());
			}
			
			// Add monsters
			for (i = 0; i < Constants.MONSTER_MAX; i++) {
				mMonsters.add(new Monster());
			}
			
			// Add items
			for (i = 0; i < Constants.ITEM_MAX; i++) {
				mItems.add(new Item());
			}
			
			// Add leader
			var l :Leader = new Leader(FlxG.width / 2 + 30 * FlxG.random(), FlxG.height / 2 + 30 * FlxG.random(), 20);
			Game.instance.boids.push(l.boid);
			mSoldiers.add(l);
			
			// Add soldiers
			for (i = 0; i < Constants.SOLDIER_MAX; i++) { 
				var s :Soldier = new Soldier(FlxG.width / 2 + 30 * FlxG.random(), FlxG.height / 2 + 30 * FlxG.random(), 20);
			
				Game.instance.boids.push(s.boid);
				mSoldiers.add(s);
			}
			
			add(new FlxSprite(0, 0, Assets.BACKGROUND));
			add(mItems);
			add(mSoldiers);
			add(mMonsters);
			add(mBullets);
			
			add(new FlxButton(FlxG.width - 90, FlxG.height - 30, "Reload", function() :void { FlxG.switchState(new PlayState()); }));
			
			super.create();
		}
		
		private function onHitByBullet(theMonster :Monster, theBullet :Bullet) :void {
			theMonster.hurt(1);
			theMonster.flicker(0.1);
			
			theBullet.kill();
		}
		
		override public function update():void {
			super.update();

			FlxG.overlap(mMonsters, mBullets, onHitByBullet);
			
			// If the mouse is pressed, command the leader to fire away!
			if (FlxG.mouse.pressed()) {
				(mSoldiers.members[0] as Leader).shoot();
			}
			
			// Debug info if "D" was pressed.
			if (FlxG.keys.justPressed("D")) {
				mDebug = !mDebug;
			}
			
			// Update the monsters respawn.
			updateMonsterQueue();
		}
		
		private function updateMonsterQueue() :void {
			if (mMonsterInterval > 0) {
				mMonsterInterval -= FlxG.elapsed;
				
				if (mMonsterInterval <= 0) {
					var aMonster :Monster = mMonsters.getFirstAvailable() as Monster;
					if (aMonster != null) {
						aMonster.spawn();
					}
					
					mMonsterInterval = Constants.MONSTER_INTERVAL;
				}
			}
		}
		
		public function get bullets() :FlxGroup { return mBullets; }
		public function get monsters() :FlxGroup { return mMonsters; }
		public function get items() :FlxGroup { return mItems; }
		public function get debug() :Boolean { return mDebug; }
	}
}