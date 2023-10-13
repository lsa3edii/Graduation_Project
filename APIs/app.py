# !pip install flask

import numpy as np
import tensorflow as tf
from keras.models import load_model
from PIL import Image
from flask import Flask, request, jsonify

model = load_model('model_image_(Brain).h5')
model.compile(optimizer = 'adam', loss = 'sparse_categorical_crossentropy', metrics = ['accuracy'])

app = Flask(__name__)

@app.route('/predict', methods = ['POST'])
def predict():
    try:
        file = request.files['image']
        img = Image.open(file)
        img = img.resize((128, 128))
        img = np.array(img.convert('RGB'))

        prediction = model.predict(img[tf.newaxis, ...])
        predicted_class = np.argmax(prediction)

        classes = ['brain_menin', 'brain_glioma', 'brain_pituitary', 'no_tumor']
        predicted_label = classes[predicted_class]

        print(prediction)
        print(predicted_class)
        print(predicted_label)
        print(prediction[0][predicted_class])

        return jsonify(
            {
                'prediction' : predicted_label,
                'accuracy' : np.double(prediction[0][predicted_class]) * 100
            }
        )

    except Exception as ex:
        return jsonify(
            {
                'error': str(ex)
            }
        )

if __name__ == '__main__':
    app.run(debug = True)
