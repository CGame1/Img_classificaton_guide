# R code to create the dataset in the 

Following instruction in the scripts will be helpfull but it should run if you supply the path to a folder containing 
1) and "images" directory with all the images you want to use for classification
2) a table with **these** 2 columns. You will have to write its name in the R script   

|      filename       | label_name |    
|:-------------------:|:---------:| 
|       character       |    character    |  
| image1.jpg | class 1  |  
| image2.jpg | class 1  | 
| image3.jpg | class 2  | 
| image4.jpg | class 2  | 


It will create the Ultralytics dataset ready for classification to use in the notebook. When the script has ran you should see

- a fodler called class_images : this is an intermediate stage where all images are placed in a folder named after their label
- a folder called YOLO_dataset : this the folder you will use with YOLO. It contains the test train and vlaidation set, the list of classes and an images metadata table for your own records

 
