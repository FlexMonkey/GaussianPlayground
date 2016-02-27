//: # Gaussian Playground
//:
//: ## Simon Gladman / [flexmonkey.blogspot.co.uk](http://flexmonkey.blogspot.co.uk/)
//:
//: Demonstration of creating a Gaussian blur using separate vertical and horizontal
//: convolution filters.

import UIKit

let sigma = 2.0

func gaussian(x: Double, sigma: Double) -> Double
{
   let variance = max(sigma * sigma, 0.00001)
    
   return (1.0 / sqrt(M_PI * 2 * variance)) * pow(M_E, -pow(x, 2) / (2 * variance))
}

var weightsArray = [CGFloat]()

for i in -4 ... 4
{
    let y = gaussian(Double(i), sigma: sigma)
    
    weightsArray.append(CGFloat(y))
}

let weightsVector = CIVector(values: weightsArray, count: weightsArray.count)

let mona = CIImage(image: UIImage(named: "monalisa.jpg")!)!

let horizontal = CIFilter(name: "CIConvolution9Horizontal",
    withInputParameters: [
        kCIInputWeightsKey: weightsVector,
        kCIInputImageKey: mona,
    ])!.outputImage!

let vertical = CIFilter(name: "CIConvolution9Vertical",
    withInputParameters: [
        kCIInputWeightsKey: weightsVector,
        kCIInputImageKey: horizontal,
    ])!

let final = vertical.outputImage
