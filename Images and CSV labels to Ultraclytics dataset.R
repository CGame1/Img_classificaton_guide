


# list packages that will be needed
packages <- c("jsonlite","httr", "imager", "magick", "tidyverse","reactablefmtr", "magrittr","insight","quarto", "RColorBrewer","Cairo", "cvms", "caret", "insight","shiny", "reactable")

# install those packages that you dont have yet
install.packages( 
  setdiff(packages,installed.packages()[,1] )
)

# Could we add a link here to reticulate/python help?
# for exampe see: 
# https://rstudio.github.io/reticulate/

# Load packages
library(reactablefmtr) # for tables display
library(shiny) # for interactive tables
library(cvms) # for evaluating model performance
library(caret) # for the model evaluation
library(insight) # for coloured prints
library(tidyverse) # for data manipulation/interaction
library(RColorBrewer) # for colour palettes
library(magrittr) # for code readability
library(jsonlite) # for interacting with JSON files
# 2) Create folders   --------------------------------------------------------------------------------

# UPDATE THE FOLLOWING:

# Set path to folder where the script is
project <- "2025007011_substrate_classes"
project_root <- "E:/2025007011"
wd <- paste0( project_root, "/",project )

# Create path to folder that contains the images. If this contains zipped folder images as in tutorial, these will be unzipped.
imagesDir <- paste0(wd, "/images")

# Create path to the folder where your Biigle reports are
path_to_labelfile <- paste0(wd , "/bottom_labels.csv") # this is the path to your labels file
 
# note that the labels file must contain: 
# - filenames: the raw filename with their exttension. no path included
# - label_name: the class names you want to use for classification

#--------------------

# Set your working directory to this folder
setwd(wd)

# Create path to folder for the class sorted dataset 
sortedImagesDir <- paste0(wd, "/class_images")
 
# Create path to folder where your train/test sorted images will be stored
v8Dir <- paste0(wd , "/V8_dataset" )
 

# set the ratios of the train/test/val splits
TRAIN_TESTVAL_SPLIT <- 0.8 # 80% of images will be used for training and 20% for testing and validation
TEST_VAL_SPLIT <- 0.5 # 50% of the test set will be used for validation and 50% for testing. set to 1 if you do not want to make a test set (yolo only needs validation and training sets)


# 1) List the csv tables - these maybe in .csv or .zip format          ----------------------------------------------------------------------------
 # Open your CSV 
path_to_labelfile %>%  read_csv() -> allLabels

# This is your table of everything  - - YOU only need these two columns
if(! all(c("filename", "label_name") %in% names(allLabels) ) ){ 
  print_color(color = "br_red", text = "filename and label_name not found in your CSV - make sure your CSV has the righ column names \n")
}

# Show a list of labels
allLabels %>% count(label_name) %>% arrange(desc(n)) %>%  print()

# Make a string of labels
distinct(allLabels, label_name) %>% pull(label_name) %>%paste(collapse ="' , '") %>%  paste0("  '", ., "'  ")
print_color(color = "blue", text = paste0("The labels in your dataset are: \n", distinct(allLabels, label_name) %>%
                                            pull(label_name) %>% paste(collapse ="' \n -'") %>%
                                            paste0(" -'", ., "'  ") , "\n\n"))

# Make a list of labels you want to take to train your model on
tibble(label_name = allLabels %>% distinct(label_name) %>%  pull) -> allLabelNames

# Make a new column of better names (rather than the Biigle catalogues names)
allLabelNames %<>% mutate( Yolo_labelNames = label_name %>%  as.factor() )

# you can also edit the Yolo_labelNames column to make the names more suitable for your model, 
# for example by removing spaces and special characters, or by making them shorter. 
# allLabelNames %<>% edit() # hashed out so the whole script can run

# Add a class code - a numerical code that will be used by yolo instead of the text labels (a.k.a. one-hot encoding)
allLabelNames %<>%  mutate( class_code = 0:(nrow(allLabelNames) -1 ))

# Add a column of abundance of each label in your dataset
allLabels %>% count(label_name) %>%
  left_join(allLabelNames, by = "label_name") %>% arrange(class_code) -> allLabelNames

# View you final table
print(allLabelNames)

# make a colour palette for the plot
extended_palette <- colorRampPalette(brewer.pal(n = 7, name = "Set1"))(allLabelNames %>%  nrow())

alllables_count_plot <- allLabels %>%  
  ggplot(aes(label_name, fill = label_name)) +
  geom_bar() + 
  theme_bw() +
  # scale_fill_brewer(palette="Dark2", name = "Label names:") + 
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5 )) +
  scale_fill_manual(values = extended_palette, name = "Label names:") +
  labs(y = "Number of unique occurences",
       x = "Label names",
       title = "Number of annotations per label names",
       caption = "This is how many examples of each class your YOLO model will be trained on")

alllables_count_plot %>% print()
# 2) Prepare dataset ===================================================================================================

# 2.1) Make a table of images and their pathways ----------------------------------------------------------------------
# make a table of images and path to each of them (discounting any zip files that may be present)
# it can deal with .png and jpg but you can adapt your code to whatever format your images are in. 
if( imagesDir %>% list.files()  %>% str_detect(pattern = ".png$") %>%  any() ){
  
  print_color(color = "br_green", text = "images are PNG  \n")
  
  imagesDir %>%  
    list.files(recursive = T, full.names = T, pattern = ".png$")   -> imgsPaths
  
  images_extension <- "png"
}else if(imagesDir %>% list.files()  %>% str_detect(pattern = ".jpeg$") %>%  any()){
  
  print_color(color = "br_green", text = "images are jpeg \n")
  
  imagesDir %>%  
    list.files(recursive = T, full.names = T, pattern = ".jpeg$")    -> imgsPaths
  
  images_extension <- "jpeg"
  
}else if(imagesDir %>% list.files()  %>% str_detect(pattern = ".jpg$") %>%  any()){
  
  print_color(color = "br_green", text = "images are JPG \n")
  
  imagesDir %>%  
    list.files(recursive = T, full.names = T, pattern = ".jpg$")    -> imgsPaths
  
  images_extension <- "jpg"
  
}else{ 
  print_color(color = "br_red", text = "images not recognised - the following extensions were found in your image folder: \n")
  imagesDir %>%  
    list.files(recursive = T, full.names = T)    -> imgsPaths
  # make a column of the extentions of the files
  imgsPaths %>%  tibble(path = .) %>% mutate(extentions = path %>% str_extract(pattern = "\\.[^.]+$") ) %>% count(ext) %>% print()
  print_color(color = "br_red", text = "Please change the code above to the format your are using and make sure they are not zipped \n")
}


 
# make a variable of image names regardless of the folder they are in 
imgsPaths %>% basename -> imgsNames

# #Nils do you plan to put folder "ALL_IMAGES" ON github? Just wondering if we really need multiple columns for variations of image file paths. Why not just have full path separate when needed. 


# Format the table
tibble(path = imgsPaths,
       filename = imgsNames) -> imgPathways



# 2.2) Link images and labels   ----------------------------------------------------------------------------

# Merge it with the the image metadata including the path and dimensions
imgPathways %>%  left_join(allLabels, . , by = "filename" ) %>% distinct(filename, .keep_all = T) -> allLabelsPath

# Make sure all labeled images are matched to their corresponding pathways
allLabelsPath %>% dplyr::filter(is.na(path)) -> mismatched # 

# Highlight any images in the biigle report that have not been found
if(nrow(mismatched) == 0){
  print_color(color = "br_green", text = "All images in annotation table have been found - proceed to making the dataset \n")
}else{
  print_color(color = "br_red", text = paste0("Warning: ", nrow(mismatched %>% distinct(filename)), " label(s) have not been matched to an image (out of ", nrow(allLabelsPath %>% distinct(filename) ),") \n"))
  print_color(color = "br_red", text = paste0("Number of labels=",nrow(allLabels), ", Number of images=", nrow(imgPathways), "\n\n"))
  print_color(color = "br_red", text = paste0("First 5 Mismatched images are: ", mismatched %>%  distinct(filename) %>% head(5)))
  
}

# 2.3) Move images to folder of the their respective classes  ----------------------------------------------------------------------------

# make path to images in the new dataset directory
labelsFolderPaths <- paste0(sortedImagesDir,"/", allLabelNames %>% pull(label_name))

# Make the class sorted images folder
if (dir.exists(sortedImagesDir)== FALSE){
  dir.create(sortedImagesDir)
  print_color(color = "bg_violet", text = paste0("Making sorted images folder at: '",sortedImagesDir,"' \n"))
 

# Export the labels as a classes.txt file
allLabelNames %>% select(label_name) %>% 
  write_csv(file = paste0(sortedImagesDir,"/classes.txt"),col_names = FALSE)

# export plot to sorted images directory
alllables_count_plot %>% print()
ggsave(filename = paste0(sortedImagesDir,"/Number_of_annotations_per_label_names.png"), 
       width = 10, height = 6, dpi = 300, device = "png", type = "cairo-png")

# make the new dataset
for (i in seq(labelsFolderPaths)) {
  
  allLabelNames %>% slice(i) -> label.i
  
  
  # Create the folders
  labeldir.i <- paste0(sortedImagesDir,"/", label.i$label_name)
  if (dir.exists(labeldir.i) == FALSE){
    dir.create(labeldir.i)
    print_color(color = "green", text = paste0("\n Making folder for label: '",label.i$label_name,"' \n"))
  }
    # all images with this label
    allLabelsPath %>% dplyr::filter(label_name == label.i$label_name) -> labels.i
    
    print_color(color = "blue", text = paste0("'",label.i$label_name, "' moving ", 
                                              nrow(labels.i), " images \n"))
    
  # move images to their new dataset 
    total_iterations <- nrow(labels.i)
    # Initialize the progress bar
    pb <- txtProgressBar(min = 0, max = total_iterations, style = 3)
  for (ii in 1:nrow(labels.i)) {
    
    labels.i %>% slice(ii) -> d.ii
    
    
    # Move the images
    file.copy(from = d.ii$path,
             to = paste0(sortedImagesDir,"/",
                         label.i$label_name,"/"
                         ,d.ii$filename), overwrite = T)
    setTxtProgressBar(pb, ii)
    
  } # end of ii loop, next label
} # end of i loop, next label
  
  }else{
    
    print_color(color = "br_red", text = paste0("'"," labels ", "' folders already exists in ",sortedImagesDir," \n"))
    stop("Sorted images folder already exists! If you made it, you can continue with the next step \n")
    }
  

# you can pick up here if you already have your folder of sorted images 

 

# 3.) Make a dataset folder for YOLO V8  --------------------------------------------------------------------------------
# Make a dataset folder
if(!dir.exists(v8Dir) ){
  dir.create(v8Dir)  
  print_color(color = "bg_violet", text = paste0("Making V8 dataset folder at: '",v8Dir,"' \n"))
  
  # Export the labels as a classes.txt file
  allLabelNames %>% select(label_name) %>% 
    write_csv(file = paste0(v8Dir,"/classes.txt"),col_names = FALSE)
  
  
  # List of labels
  labels <- list.dirs(sortedImagesDir,recursive = F, full.names = F)
  
  # Data set folder name not a label
  labels %<>% str_subset(pattern = "V8_dataset",negate = T)
  
  # Yolo folder not a label
  labels %<>% str_subset(pattern = "yolo",negate = T)
  
  # Make train and test folders
  train <- paste0( v8Dir , "/train" )
  dir.create(train)
  # Make directory for each labels 
  for (label in labels) {
    dir.create(paste0(train,"/",label))
    
  }
  

  
  # Same for validation set
  val <- paste0( v8Dir , "/val" ) 
  dir.create(val)
  for (label in labels) {
    dir.create(paste0(val,"/",label))
  }
  
  # Same for test set
  if(TEST_VAL_SPLIT != 1){
    test <- paste0( v8Dir , "/test" ) 
    dir.create(test)
    for (label in labels) {
      dir.create(paste0(test,"/",label))
    }
  }else{
    print_color(color = "blue", text = "No test set will be created - only train and val \n")
    test <- NULL
  }
  
  
  
  # copy images to their assigned train, validation and test folders
  imagesMeta <- as.list(labels)
  names(imagesMeta) <- labels
  
   # Initialize the progress bar
  pb <- txtProgressBar(min = 0, max = total_iterations, style = 3)
  
  for(label in labels){
    
    print_color(color = "green", text = paste0( "\n moving '",label ,"' images to Val folder\n"))
    # read image names that have the extension you chose
    labImgs <- list.files(paste0(sortedImagesDir,"/",label),
                          pattern = paste0(".",images_extension,"$") )
    
    # use set proportion images in training and 10 (20/2) in test and val
    labImgsTrain <- labImgs %>% sample(length(.)*TRAIN_TESTVAL_SPLIT)
    
    # split Test into test and val
    labImgsTestval <- setdiff( labImgs, labImgsTrain)
    
    labImgsVal <- labImgsTestval %>% sample(length(.)*TEST_VAL_SPLIT)
 
      
    labImgsTest<- setdiff( labImgsTestval, labImgsVal)
    
    # make a summary table of the images  
    bind_rows(tibble(filename = labImgsTrain, set = "train"),
              tibble(filename = labImgsTest, set = "test"), 
              tibble(filename = labImgsVal, set = "val")
    ) %>% mutate(label = label) -> imagesMeta[[label]]
    

    
    
    # move images to their new dataset 
    pb <- txtProgressBar(min = 0, max = length(labImgsVal), style = 3)
    for(image in  labImgsVal){
      file.copy(from = paste0(sortedImagesDir,"/",label,"/",image),
                to = paste0(val,"/",label))
      setTxtProgressBar(pb, which(labImgsVal == image))
    }
    
    # if the TEST_VAL_SPLIT is not set to 1
    if(TEST_VAL_SPLIT != 1){
      
      print_color(color = "green", text = paste0( "\n moving '",label ,"' images to Test folder\n"))
      pb <- txtProgressBar(min = 0, max = length(labImgsTest), style = 3)
      for(image in  labImgsTest){
        file.copy(from = paste0(sortedImagesDir,"/",label,"/",image),
                  to = paste0(test,"/",label))
        setTxtProgressBar(pb, which(labImgsTest == image))
      }
    } # only if test set is enabled 
    

    print_color(color = "green", text = paste0( "\n moving '",label ,"' images to Train folder\n"))
    pb <- txtProgressBar(min = 0, max = length(labImgsTrain), style = 3)
    for(image in  labImgsTrain){
      file.copy(from = paste0(sortedImagesDir,"/",label,"/",image),
                to = paste0(train,"/",label))
      setTxtProgressBar(pb, which(labImgsTrain == image))
    }
    
    
    
    
  } # end of image copying per label loop
  
  imagesMeta %<>% bind_rows() %>%
    mutate(path = paste0(sortedImagesDir,"/",label)) %>% 
    select(filename,path,label,set)
  
  imagesMeta %>% write_csv(paste0(sortedImagesDir,"/Image_metadata.csv"))
  # also export in the V8 dataset for reference
  imagesMeta %>% write_csv(paste0(v8Dir,"/Image_metadata.csv"))
  
}else{  
  
  stop("Dataset directory already exists!!\n") 
}# will stop if V8 dir already exists


# 4 ) Visualise the dataset  --------------------------------------------------------------------------------

paste0(sortedImagesDir,"/Image_metadata.csv") %>%  read_csv() -> imagesMeta

# this will create an interactive table where you can visualise 

imagesMeta %>% count(label, set ) %>%
  mutate(color_pal = case_when(
    str_detect(set, "test") ~ "#FF3B28",
    str_detect(set, "train") ~ "#006FEF" ,
    str_detect(set, "val") ~ "#66a32e" 
  )) %>% 
  reactable(
    .,
    defaultColDef = colDef(
      cell = data_bars(.,
                       fill_color_ref = "color_pal",
                       border_style = "solid",
                       border_color = "gold", 
                       text_position = "outside-end")
    ),
    columns = list(color_pal = colDef(show = FALSE) ), # Hide the color_pal column
    defaultPageSize = 50 
     
    
  )


# open it in new window with a shiny app 
ui <- fluidPage(
  
  # this will create an ineractive table where you can visualise 
  
  imagesMeta %>% count(label, set ) %>%
    mutate(color_pal = case_when(
      str_detect(set, "test") ~ "#FF3B28",
      str_detect(set, "train") ~ "#006FEF" ,
      str_detect(set, "val") ~ "#66a32e" 
    )) %>% 
    reactable(
      .,
      defaultColDef = colDef(
        cell = data_bars(.,
                         fill_color_ref = "color_pal",
                         border_style = "solid",
                         border_color = "gold", 
                         text_position = "outside-end")
      ),
      columns = list(color_pal = colDef(show = FALSE) ), # Hide the color_pal column
      defaultPageSize = 50 
      
      
    )
)

server <- function(input, output) {
  output$table <- renderReactable({ })
}

shinyApp(ui, server)
  
  