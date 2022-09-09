//
//  VisualizerView.m
//  iPodVisualizer
//
//  Created by Xinrong Guo on 13-3-30.
//  Copyright (c) 2013 Xinrong Guo. All rights reserved.
//

#import "VisualizerView.h"
#import <QuartzCore/QuartzCore.h>
#import "MeterTableOC.h"

@implementation VisualizerView {
  CAEmitterLayer *emitterLayer;
    //MeterTable meterTable;
    MeterTableOC *mt;
    
}

+ (Class)layerClass {
  return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setBackgroundColor:[UIColor blackColor]];
    emitterLayer = (CAEmitterLayer *)self.layer;
    
    CGFloat width = MAX(frame.size.width, frame.size.height);
    CGFloat height = MIN(frame.size.width, frame.size.height);
   // emitterLayer.emitterPosition = CGPointMake(width/2, height/2);
    emitterLayer.emitterPosition = CGPointMake(height/2,width/2);
    emitterLayer.emitterSize = CGSizeMake(60,width);//width-80, 60
    emitterLayer.emitterShape = kCAEmitterLayerRectangle;
    emitterLayer.renderMode = kCAEmitterLayerAdditive;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.name = @"cell";
    
    CAEmitterCell *childCell = [CAEmitterCell emitterCell];
    childCell.name = @"childCell";
    childCell.lifetime = 1.0f / 60.0f;
    childCell.birthRate = 60.0f;
    childCell.velocity = 0.0f;
    
    childCell.contents = (id)[[UIImage imageNamed:@"particleTexture.png"] CGImage];
    
    cell.emitterCells = @[childCell];
    
    cell.color = [[UIColor colorWithRed:1.0f green:0.53f blue:0.0f alpha:0.8f] CGColor];
    cell.redRange = 0.46f;
    cell.greenRange = 0.49f;
    cell.blueRange = 0.67f;
    cell.alphaRange = 0.55f;
    
    cell.redSpeed = 0.11f;
    cell.greenSpeed = 0.07f;
    cell.blueSpeed = -0.25f;
    cell.alphaSpeed = 0.15f;
    
    cell.scale = 0.5f;
    cell.scaleRange = 0.5f;
    
    cell.lifetime = 1.0f;
    cell.lifetimeRange = .25f;
    cell.birthRate = 80;
    
    cell.velocity = 100.0f;
    cell.velocityRange = 300.0f;
    cell.emissionRange = M_PI * 2;
    
    emitterLayer.emitterCells = @[cell];

    CADisplayLink *dpLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [dpLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
  }
  return self;
}

- (void)update
{
  float scale = 0.5;
  if (_audioPlayer.playing )
  {
    [_audioPlayer updateMeters];
    
    float power = 0.0f;
    for (int i = 0; i < [_audioPlayer numberOfChannels]; i++) {
      power += [_audioPlayer averagePowerForChannel:i];
    }
    power /= [_audioPlayer numberOfChannels];
      
      if (!mt){
          mt = [MeterTableOC new];
      }
    
    //float level = meterTable.ValueAt(power);
    float level = [mt valueAt:power];
    scale = level * 5;
      
      
      
      
  }
 
  [emitterLayer setValue:@(scale) forKeyPath:@"emitterCells.cell.emitterCells.childCell.scale"];
}

@end
