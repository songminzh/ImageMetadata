# what is this?

ImageMetadata is a tool to read and write metadata of image.

# how to use

You can select a image in the album of your phone and read metadata of Exif,GPS and tiff.when adding data in a image,to write with a specific format and saves,the image will contain the data you need.

# codes

* Use UIImagePickerController to support the function of album browsing,you need import ```<AssetsLibrary/AssetsLibrary.h>``` and ```<ImageIO/ImageIO.h>```,add the delegate of ```UIImagePickerControllerDelegate``` and ```UINavigationBarDelegate```.


* Add the imagePickerController to browse local album


	```
	UIImagePickerController *ctrl = [[UIImagePickerController alloc] init];
	ctrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	trl.delegate = self;
	[self presentViewController:ctrl animated:YES completion:nil];
	    
	```
* Read and write data in the method imagePickerController: didFinishPickingMediaWithInfo of UIImagePickerControllerDelegate.
