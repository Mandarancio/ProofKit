import XCTest
@testable import ProofKitTests
@testable import ADTTests
@testable import EqProofTests



XCTMain([
	 testCase(ProofKitLibTests.allTests),
     testCase(ADTTests.allTests),
     testCase(EqProofTests.allTests)
])
