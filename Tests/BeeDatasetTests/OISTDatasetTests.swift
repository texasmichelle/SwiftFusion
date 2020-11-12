// Copyright 2020 The SwiftFusion Authors. All Rights Reserved.
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

import BeeDataset
import Foundation
import PenguinParallelWithFoundation
import XCTest

final class OISTDatasetTests: XCTestCase {
  /// Test that we can download the dataset from the internet and load the dataset into memory.
  func testDownloadDataset() throws {
    if let _ = ProcessInfo.processInfo.environment["CI"] {
      throw XCTSkip("Test skipped on CI because it downloads a lot of data.")
    }
    let video = OISTBeeVideo(deferLoadingFrames: true)!
    XCTAssertEqual(video.frameIds.count, 361)
    XCTAssertEqual(video.tracks.count, 20)
    XCTAssertEqual(video.tracks[0].startFrameIndex, 0)
    XCTAssertEqual(video.tracks[0].boxes.count, 361)
    XCTAssertEqual(video.tracks[11].startFrameIndex, 28)
    XCTAssertEqual(video.tracks[11].boxes.count, 179)
  }

  /// Test that eager dataset loading works properly.
  func testEagerDatasetLoad() throws {
    if let _ = ProcessInfo.processInfo.environment["CI"] {
      throw XCTSkip("Test skipped on CI because it downloads a lot of data.")
    }
    ComputeThreadPools.local =
      NonBlockingThreadPool<PosixConcurrencyPlatform>(name: "mypool", threadCount: 5)

    // Truncate the frames so that this test does not take a huge amount of time.
    let video = OISTBeeVideo(truncate: 15)!

    XCTAssertEqual(video.frames.count, 15)
    XCTAssertNotEqual(video.frames[1], video.frames[2])

    // There are fewer tracks because we truncated the frames.
    XCTAssertEqual(video.tracks.count, 13)

    // The tracks are shorter because we truncated the frames.
    XCTAssertEqual(video.tracks[0].boxes.count, 15)
  }
}