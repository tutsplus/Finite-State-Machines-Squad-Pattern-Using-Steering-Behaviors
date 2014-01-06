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
	import flash.display.MovieClip;
	import flash.geom.Vector3D;
	
	public class Boid extends MovieClip
	{
		public static const MAX_FORCE 			:Number = 5.4;
		public static const MAX_VELOCITY 		:Number = 3;
		
		// Leader sight evasion
		public static const LEADER_BEHIND_DIST	:Number = 50;
		public static const LEADER_SIGHT_RADIUS	:Number = 30;
		
		// Separation
		public static const MAX_SEPARATION 		:Number = 2.0;
		public static const SEPARATION_RADIUS 	:Number = 50;
		
		// Wander
		public static const CIRCLE_DISTANCE 	:Number = 6;
		public static const CIRCLE_RADIUS 		:Number = 8;
		public static const ANGLE_CHANGE 		:Number = 1;
		
		public var position 	:Vector3D;
		public var velocity 	:Vector3D;
		public var desired 		:Vector3D;
		public var ahead 		:Vector3D;
		public var behind 		:Vector3D;
		public var steering 	:Vector3D;
		public var mass			:Number;
		public var wanderAngle	:Number;
		
		public function Boid(posX :Number, posY :Number, totalMass :Number) {
			position 	= new Vector3D(posX, posY);
			velocity 	= new Vector3D(-1, -2);
			desired	 	= new Vector3D(0, 0); 
			steering 	= new Vector3D(0, 0); 
			ahead 		= new Vector3D(0, 0); 
			behind 		= new Vector3D(0, 0); 
			mass	 	= totalMass;
			wanderAngle = 0; 
			
			truncate(velocity, MAX_VELOCITY);
			
			x = position.x;
			y = position.y;
			
			graphics.lineStyle(2, 0xffaabb);
			graphics.beginFill(0xFF0000);
			graphics.moveTo(0, 0);
			graphics.lineTo(0, -20);
			graphics.lineTo(10, 20);
			graphics.lineTo(-10, 20);
			graphics.lineTo(0, -20);
			graphics.endFill();
			
			graphics.moveTo(0, 0);
		}
		
		public function seek(target :Vector3D, slowingRadius :Number = 0) :Vector3D {
			var force :Vector3D;
			var distance :Number;
			
			desired = target.subtract(position);
			
			distance = desired.length;
			desired.normalize();
			
			if (distance <= slowingRadius) {
				desired.scaleBy(MAX_VELOCITY * distance/slowingRadius);
			} else {
				desired.scaleBy(MAX_VELOCITY);
			}
			
			force = desired.subtract(velocity);
			
			return force;
		}
		
		public function arrive(target :Vector3D, slowingRadius :Number = 200) :Vector3D {
			return seek(target, slowingRadius);
		}
		
		public function flee(target :Vector3D) :Vector3D {
			var force :Vector3D;
			
			desired = position.subtract(target);
			desired.normalize();
			desired.scaleBy(MAX_VELOCITY);
			
			force = desired.subtract(velocity);
			
			return force;
		}
		
		public function evade(target :Boid) :Vector3D {
			var distance :Vector3D = target.position.subtract(position);
			
			var updatesNeeded :Number = distance.length / MAX_VELOCITY;
			
			var tv :Vector3D = target.velocity.clone();
			tv.scaleBy(updatesNeeded);
			
			var targetFuturePosition :Vector3D = target.position.clone().add(tv);
			
			return flee(targetFuturePosition);
		}
		
		public function wander() :Vector3D {
			var wanderForce :Vector3D, circleCenter:Vector3D, displacement:Vector3D;
			
			circleCenter = velocity.clone();
			circleCenter.normalize();
			circleCenter.scaleBy(CIRCLE_DISTANCE);
			
			displacement = new Vector3D(0, -1);
			displacement.scaleBy(CIRCLE_RADIUS);
			
			setAngle(displacement, wanderAngle);
			wanderAngle += Math.random() * ANGLE_CHANGE - ANGLE_CHANGE * .5;
			
			wanderForce = circleCenter.add(displacement);
			
			return wanderForce;
		}
		
		// Link: http://gamedev.tutsplus.com/tutorials/implementation/the-three-simple-rules-of-flocking-behaviors-alignment-cohesion-and-separation/
		public function separation() :Vector3D {
			var force :Vector3D = new Vector3D();
			var neighborCount :int = 0;
			
			for (var i:int = 0; i < Game.instance.boids.length; i++) {
				var b :Boid = Game.instance.boids[i];
				
				if (b != this && distance(b, this) <= SEPARATION_RADIUS) {
					force.x += b.position.x - this.position.x;
					force.y += b.position.y - this.position.y;
					neighborCount++;
				}
			}
			
			if (neighborCount != 0) {
				force.x /= neighborCount;
				force.y /= neighborCount;
				
				force.scaleBy( -1);
			}
			
			force.normalize();
			force.scaleBy(MAX_SEPARATION);
			
			return force;
		}
		
		public function followLeader(leader :Boid) :Vector3D {
			var tv 		:Vector3D 	= leader.velocity.clone();
			var force 	:Vector3D	= new Vector3D();
			
			tv.normalize();
			tv.scaleBy(LEADER_BEHIND_DIST);
			
			ahead = leader.position.clone().add(tv);
			
			tv.scaleBy(-1);
			behind = leader.position.clone().add(tv);
				
			if (isOnLeaderSight(leader, ahead)) {
				alpha = 0.4;
				force = force.add(evade(leader));
				force.scaleBy(1.8); // make evade force stronger...
			} else {
				alpha = 1;
			}
			
			force = force.add(arrive(behind, 50));
			force = force.add(separation());
			
			return force;
		}
		
		private function isOnLeaderSight(leader :Boid, leaderAhead :Vector3D) :Boolean {
			return distance(leaderAhead, this) <= LEADER_SIGHT_RADIUS || distance(leader.position, this) <= LEADER_SIGHT_RADIUS;
		}
		
		private function distance(a :Object, b :Object) :Number {
			return Math.sqrt((a.x - b.x) * (a.x - b.x)  + (a.y - b.y) * (a.y - b.y));
		}
		
		public function truncate(vector :Vector3D, max :Number) :void {
			var i :Number;

			i = max / vector.length;
			i = i < 1.0 ? i : 1.0;
			
			vector.scaleBy(i);
		}
		
		public function getAngle(vector :Vector3D) :Number {
			return Math.atan2(vector.y, vector.x);
		}
		
		public function setAngle(vector :Vector3D, value:Number):void {
			var len :Number = vector.length;
			vector.x = Math.cos(value) * len;
			vector.y = Math.sin(value) * len;
		}
		
		public function update():void {
			truncate(steering, MAX_FORCE);
			steering.scaleBy(1 / mass);
			
			velocity = velocity.add(steering);
			truncate(velocity, MAX_VELOCITY);
			
			position = position.add(velocity);
			
			x = position.x;
			y = position.y;
			
			// Adjust boid rodation to match the velocity vector.
			rotation = (180 * getAngle(velocity)) / Math.PI;
		}
	}
}