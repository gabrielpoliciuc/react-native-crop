import { NativeModules } from "react-native";

const { Crop } = NativeModules;

/**
 *
 * @param {string} base64img input image in base64 format
 * @param {{x:number, y:number width:number, height:number}} cropArea
 * x, y specify the starting point coordonates. From the starting point we go with width and height to
 * define our crop area.
 * @returns {Promise<string>} a new base64 image of the cropped area
 * @throws Error if cropping failed due to invalid base64 input img or incorrect cropArea
 */
export default function CropBase64Img(base64img, cropArea) {
  return new Promise((resolve, reject) => {
    Crop.crop(
      base64img,
      cropArea.x,
      cropArea.y,
      cropArea.width,
      cropArea.height,
      croppedImage => {
        if (croppedImage !== "") {
          resolve(`data:image/png;base64,${croppedImage}`);
        }
        reject(new Error("Provided base64img or crop area is in incorrect format."));
      }
    );
  })
}
