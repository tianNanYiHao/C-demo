//
//  DWFParticleView.m
//  DrawWithFire
//
//  Created by Ray Wenderlich on 10/6/11.
//  Copyright 2011 Razeware LLC. All rights reserved.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DWFParticleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DWFParticleView
{
    CAEmitterLayer* fireEmitter; //1
}

-(void)awakeFromNib
{
    //set ref to the layer
    fireEmitter = (CAEmitterLayer*)self.layer; //2
    //configure the emitter layer
    fireEmitter.emitterPosition = CGPointMake(50, 50);
    fireEmitter.emitterSize = CGSizeMake(10, 10);
    
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    fire.birthRate = 200;           //粒子发生数
    fire.lifetime = 2.0;            //粒子生命时间
    fire.lifetimeRange = 0.5;
    fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
    fire.contents = (id)[[UIImage imageNamed:@"Particles_fire.png"] CGImage];
    [fire setName:@"fire"];

    fire.velocity = 100;            //粒子发射速度
    fire.velocityRange = 200;       //粒子发射速度的变化范围
    fire.emissionRange = M_PI;
    
    fire.scaleSpeed = 0.9;          //缩放速度 (变大速度) 数值越大 变大越快
    fire.spin = 0.6;                //旋转
    
    fireEmitter.renderMode = kCAEmitterLayerAdditive;
    
    //add the cell to the layer and we're done
    fireEmitter.emitterCells = [NSArray arrayWithObject:fire];
    
}

+ (Class) layerClass //3
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

-(void)setEmitterPositionFromTouch: (UITouch*)t
{
    //change the emitter's position
    fireEmitter.emitterPosition = [t locationInView:self];
}

-(void)setIsEmitting:(BOOL)isEmitting
{
    //turn on/off the emitting of particles
    [fireEmitter setValue:[NSNumber numberWithInt:isEmitting?200:0] forKeyPath:@"emitterCells.fire.birthRate"];
}


@end
