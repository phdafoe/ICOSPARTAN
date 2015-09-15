/*==============================
 
 - WazzUp -
 
 Chat App Template made by FV iMAGINATION - 2015
 for codecanyon.net
 
 ===============================*/



#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "Camera.h"


#pragma mark - PHOTOCAMERA METHOD ============================
BOOL OpenCamera(id target, BOOL canEdit) {
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == false)
        return false;

	UIImagePickerController *photoCamera = [[UIImagePickerController alloc] init];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]
		&& [[UIImagePickerController availableMediaTypesForSourceType:
			 UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage]) {
		photoCamera.mediaTypes = @[(NSString *) kUTTypeImage];
		photoCamera.sourceType = UIImagePickerControllerSourceTypeCamera;
		
		if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
			photoCamera.cameraDevice = UIImagePickerControllerCameraDeviceRear;
		} else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
			photoCamera.cameraDevice = UIImagePickerControllerCameraDeviceFront;
		}
        
	} else return false;
	
	photoCamera.allowsEditing = canEdit;
	photoCamera.showsCameraControls = true;
	photoCamera.delegate = target;
	
	[target presentViewController:photoCamera animated:true completion:nil];
	
    
	return true;
}




#pragma mark - PHOTO LIBRARY METHOD ============================
BOOL OpenPhotoLibrary(id target, BOOL canEdit) {
	if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] == false
		 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] == false))
        return false;

    UIImagePickerController *photoCamera = [[UIImagePickerController alloc] init];
	
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]
		&& [[UIImagePickerController availableMediaTypesForSourceType:
			 UIImagePickerControllerSourceTypePhotoLibrary] containsObject:(NSString *)kUTTypeImage]) {
		photoCamera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		photoCamera.mediaTypes = @[(NSString *) kUTTypeImage];
	
    } else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]
			 && [[UIImagePickerController availableMediaTypesForSourceType:
				  UIImagePickerControllerSourceTypeSavedPhotosAlbum] containsObject:(NSString *)kUTTypeImage]) {
		photoCamera.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		photoCamera.mediaTypes = @[(NSString *) kUTTypeImage];
	} else return false;
	
	photoCamera.allowsEditing = canEdit;
	photoCamera.delegate = target;
	
	[target presentViewController:photoCamera animated:true completion:nil];
	
	return true;
}

