//: # Gaussian Playground
//:
//: ## Simon Gladman / [flexmonkey.blogspot.co.uk](http://flexmonkey.blogspot.co.uk/)
//:
//: Demonstration of creating a Gaussian blur using separate vertical and horizontal
//: convolution filters.

import UIKit

let sigma = 4.0

extension CIVector
{
    func normalize() -> CIVector
    {
        var sum: CGFloat = 0
        
        for i in 0 ..< self.count
        {
            sum += self.valueAtIndex(i)
        }
        
        if sum == 0
        {
            return self
        }
        
        var normalizedValues = [CGFloat]()
        
        for i in 0 ..< self.count
        {
            normalizedValues.append(self.valueAtIndex(i) / sum)
        }
        
        return CIVector(values: normalizedValues,
                        count: normalizedValues.count)
    }
}

func gaussian(x: Double, sigma: Double) -> Double
{
   let variance = max(sigma * sigma, 0.00001)
    
   return (1.0 / sqrt(M_PI * 2 * variance)) * pow(M_E, -pow(x, 2) / (2 * variance))
}



let weightsArray: [CGFloat] = (-4).stride(through: 4, by: 1).map
{
    CGFloat(gaussian(Double($0), sigma: sigma))
}


let weightsVector = CIVector(values: weightsArray,
                             count: weightsArray.count).normalize()

let image = CIImage(image: UIImage(named: "DSCF0489.jpg")!)!

let horizontalBluredImage = CIFilter(name: "CIConvolution9Horizontal",
    withInputParameters: [
        kCIInputWeightsKey: weightsVector,
        kCIInputImageKey: image,
    ])!.outputImage!

let verticalBlurredImage = CIFilter(name: "CIConvolution9Vertical",
    withInputParameters: [
        kCIInputWeightsKey: weightsVector,
        kCIInputImageKey: horizontalBluredImage,
    ])!

let final = verticalBlurredImage.outputImage

