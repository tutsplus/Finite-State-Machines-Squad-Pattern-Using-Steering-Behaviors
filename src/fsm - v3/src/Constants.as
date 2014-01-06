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
	import org.flixel.FlxG;

	public class Constants 
	{
		public static const GAME_ORG_WIDTH							:uint = 600;
		public static const GAME_ORG_HEIGHT							:uint = 480;
		
		public static const BUFFER_WIDTH 							:int = 600;
		public static const BUFFER_HEIGHT 							:int = 480;
		public static const BUFFER_ZOOM 							:Number = 1;
		
		public static const WORLD_WIDTH 							:Number = 1000;
		public static const WORLD_HEIGHT 							:Number = 1000;
		
		public static const MONSTER_MAX 							:int = 20;
		public static const MONSTER_INTERVAL 						:Number = 2; // in seconds
		public static const MONSTER_LIFE 							:Number = 5;
		public static const MONSTER_LOT_CHANCE 						:Number = 0.5;
		
		public static const SOLDIER_MAX 							:int = 5;
		public static const SOLDIER_SHOOTING_LAG 					:Number = 0.2; // in seconds
		
		public static const ITEM_MAX 								:int = MONSTER_MAX;
		public static const ITEM_MEDKIT_TTL 						:Number = 4; // in seconds
		public static const ITEM_BADKIT_TTL 						:Number = 2; // in seconds
		
		public static const BULLET_SPEED 							:Number = 500;
		public static const BULLET_MAX	 							:int = 50;
		public static const BULLET_DAMAGE	 						:Number = 5;
	}
}