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
	
	/**
	 * Describes an item. It can be a good item, e.g. medkit, or a bad one, e.g. monster BADKIT.
	 */
	public class Item extends FlxSprite
	{
		public static const BADKIT 	:String = "badkit";
		public static const MEDKIT 	:String = "medkit";
		
		private var mType 			:String;
		private var mTimeToLive 	:Number;
		
		public function Item() {
			loadGraphic(Assets.ITEMS, true, false, 20, 20, true);
			addAnimation(BADKIT, 		[1]);
			addAnimation(MEDKIT, 	[0]);
			
			kill();
		}
		
		public function respawn(theX :Number, theY :Number) :void {
			mType = FlxG.random() <= 0.5 ? BADKIT : MEDKIT;
			
			mTimeToLive = mType == BADKIT ? Constants.ITEM_BADKIT_TTL : Constants.ITEM_MEDKIT_TTL;
			
			play(mType);
			reset(theX, theY);
		}
		
		override public function update():void {
			super.update();
			
			if (mTimeToLive > 0) {
				mTimeToLive -= FlxG.elapsed;
				
				// If it item is about to be removed, flicker it a little bit.
				if (mTimeToLive <= 1.5) {
					flicker(0.1);
				}
				
				// Time out!
				if (mTimeToLive <= 0) {
					kill();
				}
			}
		}
		
		public function get type() :String { return mType; }
	}
}