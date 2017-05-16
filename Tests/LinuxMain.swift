import XCTest
@testable import ProofKitLibTests
@testable import ADTTests
@testable import EqProofTests



XCTMain([
	 testCase(ProofKitLibTests.allTests),
     testCase(ADTTests.allTests),
     testCase(EqProofTests.allTests)
])
