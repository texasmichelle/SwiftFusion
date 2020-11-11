// Copyright 2019 The SwiftFusion Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/// This file tests proper Naive Bayes behavior

// This file tests for the CGLS optimizer

import SwiftFusion
import TensorFlow
import XCTest

final class NaiveBayesTests: XCTestCase {
  func testGaussianNBFittingParams() {
    let data = Tensor<Double>(randomNormal: [5000, 10, 10], mean: Tensor(4.888), standardDeviation: Tensor(2.999))
    var gnb = GaussianNB(dims: data.shape.dropFirst())

    gnb.fit(data)

    let sigma = Tensor<Double>.init(ones: [10, 10]) * 2.999
    let mu = Tensor<Double>.init(ones: [10, 10]) * 4.888
    
    assertEqual(gnb.sigmas!, sigma, accuracy: 3e-1)
    assertEqual(gnb.mus!, mu, accuracy: 3e-1)
  }

  func testGaussianNB() {
    let data = Tensor<Double>([[0.9], [1.1]])
    var gnb = GaussianNB(dims: data.shape.dropFirst())

    gnb.fit(data)

    let sigma = data.standardDeviation().scalar!
    let mu = data.mean().scalar!
    let p: Double = 0.4
    let g: Double = (1.0 / (sigma * sqrt(2.0 * Double.pi))) * exp(-0.5 * pow(p - mu, 2)/(sigma * sigma))

    assertEqual(
      Tensor<Double>([gnb.negativeLogLikelihood(Tensor<Double>([p]))]),
      Tensor<Double>([-log(g)]), accuracy: 1e-8)
  }
}
