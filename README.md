# Graduation Project
## Overview:
Our project investigates the use of deep learning technology in the medical field, it is a medical diagnosis system for brain cancer that works using artificial intelligence algorithms such as deep learning techniques especially CNNs, for the model to classify magnetic resonance images (MRI), because traditional methods for classifying brain tumours take a long time to complete. Manual inspection and subject to human error. Therefore, we decided to create a mobile application with many features and linked it to the deep learning model that we had previously trained via an API to help doctors and patients identify whether patients have brain cancer or not.

We have created a mobile app to use the deep learning model smoothly and easily.
- Users in our System → (Admin, Patients, and Doctor).

We have created a backend system to handle Firebase, Flutter UI, API, and deep learning model together, and API controller that facilitates seamless communication among different components of the system, ensuring efficient data flow and interaction.

## Documentation & Presentation & Videos:
- https://drive.google.com/drive/folders/1-nBuDhLhixJS_Xvh3dno9dHhzX-mTJ1d?usp=drive_link

## Explanation of CNN Model:
In this video, I personally explain our deep learning model: https://youtu.be/B4n_O51cDB0?si=b8SmDj6EP-moFNME

## Technologies & Tools:
- Python Language
- Jupyter Notebook
- Colab Notebook
- Flask Framework
- Dart Language
- Flutter Framework
- Firebase & Database
- Android Studio
- VS Code

## Some of Features:
- Registration & Login & Logout
- Google Authentication
- Facebook Authentication
- Email Verification & Data Validation
- Chatting with doctor
- Searching for certain user
- Reset Password
- Change Profile Data
- Manage Users (Add & Delete)
- Use AI to predict brain cancer MRI
- Contact with developer

## Workflow:
![Pipeline](https://github.com/lsa3edii/Test/assets/87280713/058d8c91-df19-40a6-b49f-278d5f5c8b51)

## Details of Our Datasets:
To create our Brain Cancer MRI (Magnetic Resonance Imaging) dataset, we collected some datasets, based on three different types of brain tumors (glioma, meningioma, pituitary) and another dataset does not contain any disease to train our model.
- Number of Samples: 20000
- [Training : Testing] Ratio → 16000 image : 4000 image → 80% : 20%
- Diminution of images: (512 * 512)
- Classes number: 4
- Classes Labels: (brain glioma, brain menin, brain pituitary, no_tumor)

## Links:
- https://www.kaggle.com/datasets/obulisainaren/multi-cancer
- https://www.kaggle.com/datasets/masoudnickparvar/brain-tumor-mri-dataset
- https://www.kaggle.com/datasets/ahmedhamada0/brain-tumor-detection
- https://www.kaggle.com/datasets/pradeep2665/brain-mri
- The dataset we collected and trained the model on it: https://drive.google.com/drive/folders/1_q7Tx93ISIR3tF4vKlco9FFPfTfOZZN7?usp=sharing

## Analysis & Distribution Datasets:
![Screenshot 2024-01-04 082717](https://github.com/lsa3edii/Test/assets/87280713/b4bafd41-ff49-4618-82b7-b9f47cf0a23f)

## Preprocessing:
Steps for our Image Preprocessing:
- Image Collection & Exploration
- Image Reading & Cleaning
- Image Resizing
- Splitting Dataset
- Save Preprocessed Images

## Model Training:
![Screenshot 2024-01-03 192332](https://github.com/lsa3edii/Test/assets/87280713/32f6df36-8093-4c74-a0c3-c4cfb1619cba)

## Accuracy & Loss Graphs:
![Screenshot 2024-01-03 192221](https://github.com/lsa3edii/Test/assets/87280713/7022a9c2-f237-4861-9d09-bb4123872bec)

## Evaluation:
![Screenshot 2024-01-03 192447](https://github.com/lsa3edii/Test/assets/87280713/614ec296-ccff-4dde-960a-f927b10197f6)
We have made some modifications to the model of the paper and changed the hyperparameters in the model many times to get the best results.

## Comparison between Models:
![Screenshot 2024-01-03 192247](https://github.com/lsa3edii/Test/assets/87280713/f5cb6fff-c4d1-42e7-b5c9-9514405435d1)

## Discussion and Notes about Custom CNN & TL Models:
- There are many problems with Alex-Net Model because it is overfitting, and model can’t work with the dataset. So, we can’t train this model and the solution is with other models, especially Custom CNN.
- VGG16 Model and Res-Net Model have shown great results in a very small number of epochs during the training, and we rely completely on our project on our Custom CNN.
- Therefore, we did not care much about training both models (VGG16 and Res-Net) any further, and we were satisfied with these results.

## Future Work:
- Make the scaling of application is larger to handle many different of users.
- Make an application version for the web to make it easier for users to use our web app.
- Add Video call for users and doctors.
- Support different languages to gain more audience from all over the world.
- Activate Facebook authentication.
- Add dark mode theme to our application.
- Train another model on object detection techniques to detect the Infected cells.
- Train another model on NLP techniques for predicting brain prescription texts.
