//
//  ProgressBarViewController.m
//  Squad
//
//  Created by MAC 6- AQB SOLUTIONS on 13/10/17.
//  Copyright © 2017 AQB Solutions. All rights reserved.
//



#import "ProgressBarViewController.h"

@interface ProgressBarViewController (){
    
    IBOutlet UIProgressView *progressBar;
    IBOutlet UIView *progressView;
    NSURLSession *uploadSession;
    NSMutableData *receivedData;
}

@end

@implementation ProgressBarViewController

@synthesize delegate,apiName,appendString,jsonString,chosenImage,isvideo,videoDataDict;

- (void)viewDidLoad {
    [super viewDidLoad];
    receivedData = [[NSMutableData alloc] init];
    
    
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isFromHeaderForOffline) {
        progressView.hidden = true;
    }else{
        progressView.hidden = false;
    }
    if (isvideo) {
        [self videoUpload];
    }else{
        [self uploadImage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//uploadMultipleImage
-(void) uploadImage{
    NSMutableURLRequest *request;
    if (_isMultiImage) {
        [self uploadMultipleImg];
        return;
        if (![Utility isEmptyCheck:_imageDataDict]) {
            request = [Utility uploadMultipleImage:@"image0" withapi:apiName append:appendString imageData:_imageDataDict jsonString:jsonString];
        } else {
            request = [Utility uploadMultipleImage:@"image0" withapi:apiName append:appendString imageData:nil jsonString:jsonString];
        }
    } else {
        if (![Utility isEmptyCheck:chosenImage]){
            
            NSData *data = UIImageJPEGRepresentation(chosenImage, 1);
            if(data){
                
            }
            float size = data.length/1024.0/1024.0; //(Converted In MB)
            NSLog(@"Uploaded Image Size:%f",size);
            if(size > 16){
                NSError *err = [NSError errorWithDomain:@"Big_Image-Size"
                                                   code:100
                                               userInfo:@{
                                                          NSLocalizedDescriptionKey:@"Your pic is too big, please reduce the size"
                                                          }];
                
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self->delegate respondsToSelector:@selector(completedWithError:)]) {
                        [self->delegate completedWithError:err];
                    }
                }];
                return;
            }
            
            
            request = [Utility uploadImageWithFileName:@"property" withapi:apiName append:appendString image:chosenImage jsonString:jsonString];
        }
        else{
            request = [Utility uploadImageWithFileName:@"property" withapi:apiName append:appendString image:nil jsonString:jsonString];
        }
    }
    
    //NSURLSessionConfiguration *sessionConfiguration = [NSURLSessioxnConfiguration backgroundSessionConfigurationWithIdentifier:@"com.TheSquat.imageUpload"];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfiguration.allowsCellularAccess = YES;
    uploadSession =[NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionUploadTask *dataTask = [uploadSession uploadTaskWithStreamedRequest:request];
    [dataTask resume];
}
-(void)uploadMultipleImg{
    //parameters if any
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *parameters = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSString *urlString = [Utility getUrl:apiName]; // an url where the request to be posted
    if (appendString.length > 0) {
        urlString =[urlString stringByAppendingFormat:@"/%@",appendString];
    }
    //Now post
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //add img data one by one
        if (![Utility isEmptyCheck:self->_imageDataDict]) {
            for(id key in self->_imageDataDict){
//                NSLog(@"key=%@ value=%@", key, [self->_imageDataDict objectForKey:key]);
                NSData *imagedata = UIImagePNGRepresentation([self->_imageDataDict objectForKey:key]);
                [formData appendPartWithFileData:imagedata name:@"image" fileName:[@"" stringByAppendingFormat:@"%@.png",key] mimeType:@"image/png"];
            }
        }
        
        [formData appendPartWithFormData:data name:@"jsonString"];
    } error:nil];
    
    //Create manager
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          self->progressBar.progress = uploadProgress.fractionCompleted;
                          NSLog(@"af networking progress - %f",uploadProgress.fractionCompleted);
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          //        NSLog(@"Error= %@",error);
                          [self dismissViewControllerAnimated:YES completion:^{
                              if ([self->delegate respondsToSelector:@selector(completedWithError:)]) {
                                  [self->delegate completedWithError:error];
                              }
                          }];
                      }
                      else{
                          NSMutableDictionary *mainDict=[[NSMutableDictionary alloc]initWithDictionary:responseObject];
                          NSData *postData = [NSJSONSerialization dataWithJSONObject:mainDict options:NSJSONWritingPrettyPrinted  error:&error];
                          NSString *responseString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
                          NSLog(@"\n response string: \n %@",responseString);
                          NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:postData options:0 error:nil];
                          if(![Utility isEmptyCheck:responseDict] && [[responseDict allKeys] containsObject:@"Message"] && [[responseDict allKeys] containsObject:@"MessageDetail"]){
                              NSMutableDictionary* details = [NSMutableDictionary dictionary];
                              [details setValue:responseDict[@"MessageDetail"] forKey:NSLocalizedDescriptionKey];
                              // populate the error object with the details
                              NSError*er = [NSError errorWithDomain:@"world" code:200 userInfo:details];
                              [self dismissViewControllerAnimated:YES completion:^{
                                  if ([self->delegate respondsToSelector:@selector(completedWithError:)]) {
                                      [self->delegate completedWithError:er];
                                  }
                              }];
                          }else{
                              [self dismissViewControllerAnimated:YES completion:^{
                                  if (self->_isFromtodayGetApiName) {
                                      if ([self->delegate respondsToSelector:@selector(completedWithResponse:responseDict:from:)]) {
                                          [self->delegate completedWithResponse:responseString responseDict:responseDict from:self->apiName];
                                      }
                                  }else{
                                      if ([self->delegate respondsToSelector:@selector(completedWithResponse:responseDict:)]) {
                                          [self->delegate completedWithResponse:responseString responseDict:responseDict];
                                      }
                                  }
                                  
                              }];
                              
                              
                              
                              
                              
                          }
                          
                      }
                  }];
    
    [uploadTask resume];
}
-(void)videoUpload{
    if (![Utility isEmptyCheck:videoDataDict]) {
        NSMutableURLRequest *request = [Utility uploadvideoWithData:videoDataDict withapi:apiName];
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.allowsCellularAccess = YES;
        uploadSession =[NSURLSession sessionWithConfiguration: sessionConfiguration delegate:self delegateQueue: [NSOperationQueue mainQueue]];
        NSURLSessionUploadTask *dataTask = [uploadSession uploadTaskWithStreamedRequest:request];
        [dataTask resume];
    }
}



#pragma mark - NSURLSession Delegate


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    dispatch_async(dispatch_get_main_queue(), ^{
        double uploadProgress = (double)totalBytesSent / (double)totalBytesExpectedToSend;
        NSLog(@"progress= %f",uploadProgress);
        self->progressBar.progress = uploadProgress;
    });
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->uploadSession finishTasksAndInvalidate];
        if (error) {
            //        NSLog(@"Error= %@",error);
            [self dismissViewControllerAnimated:YES completion:^{
                if ([self->delegate respondsToSelector:@selector(completedWithError:)]) {
                    [self->delegate completedWithError:error];
                }
            }];
        }
        else{
            NSString* responseString = [[NSString alloc] initWithData:self->receivedData encoding:NSUTF8StringEncoding];
            NSLog(@"\n response string: \n %@",responseString);
            NSDictionary *responseDict= [NSJSONSerialization JSONObjectWithData:self->receivedData options:0 error:nil];
            if(![Utility isEmptyCheck:responseDict] && [[responseDict allKeys] containsObject:@"Message"] && [[responseDict allKeys] containsObject:@"MessageDetail"]){
                NSMutableDictionary* details = [NSMutableDictionary dictionary];
                [details setValue:responseDict[@"MessageDetail"] forKey:NSLocalizedDescriptionKey];
                // populate the error object with the details
                NSError*er = [NSError errorWithDomain:@"world" code:200 userInfo:details];
                [self dismissViewControllerAnimated:YES completion:^{
                    if ([self->delegate respondsToSelector:@selector(completedWithError:)]) {
                        [self->delegate completedWithError:er];
                    }
                }];
            }else{
                [self dismissViewControllerAnimated:YES completion:^{
                    if (self->_isFromtodayGetApiName) {
                        if ([self->delegate respondsToSelector:@selector(completedWithResponse:responseDict:from:)]) {
                            [self->delegate completedWithResponse:responseString responseDict:responseDict from:self->apiName];
                             }
                    }else{
                        if ([self->delegate respondsToSelector:@selector(completedWithResponse:responseDict:)]) {
                            [self->delegate completedWithResponse:responseString responseDict:responseDict];
                    }
                    }
                }];
            }
            
        }
    });
    
}


-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    //     NSLog(@"### handler 1");
    completionHandler(NSURLSessionResponseAllow);
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->receivedData appendData:data];
    });
}

#pragma Mark End




@end
