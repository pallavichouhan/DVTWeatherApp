//
//  DVTWeatherTests.swift
//  DVTWeatherTests
//
//  Created by Pallavi Chouhan on 2020/02/07.
//  Copyright © 2020 Pallavi Chouhan. All rights reserved.
//

import XCTest
@testable import DVTWeather

class DVTWeatherTests: XCTestCase {
    
    var weatherService: WeatherService!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        weatherService = WeatherService()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        weatherService = nil
    }
    
    func testParseNonJsonString() {
        let data = "Just a plain error".data(using: String.Encoding.utf8)!
        let weatherModel = weatherService.parseJSON(data)
        if weatherModel == nil {
            XCTFail("Couldn't recognize malformed JSON response")
            return
        }
    }
    
    func testParseJsonWithoutExpectedValues() {
        let data = "{ \"foo\": 42.0, \"main\": \"hello\" }".data(using: String.Encoding.utf8)!
        let weatherModel = weatherService.parseJSON(data)
        if weatherModel == nil {
            XCTFail("Couldn't recognize malformed JSON response")
            return
        }
    }
    
    func testParseValidJson() {

        let newData = "{\"cod\":\"200\",\"message\":0,\"cnt\":1,\"list\":[{\"dt\":1581066000,\"main\":{\"temp\":31.51,\"feels_like\":29.4,\"temp_min\":27.79,\"temp_max\":31.51,\"pressure\":1015,\"sea_level\":1015,\"grnd_level\":849,\"humidity\":36,\"temp_kf\":3.72},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":56},\"wind\":{\"speed\":5.12,\"deg\":2},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2020-02-07 09:00:00\"},{\"dt\":1581076800,\"main\":{\"temp\":31.56,\"feels_like\":29.53,\"temp_min\":28.77,\"temp_max\":31.56,\"pressure\":1012,\"sea_level\":1012,\"grnd_level\":847,\"humidity\":34,\"temp_kf\":2.79},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04d\"}],\"clouds\":{\"all\":58},\"wind\":{\"speed\":4.6,\"deg\":345},\"sys\":{\"pod\":\"d\"},\"dt_txt\":\"2020-02-07 12:00:00\"}],\"city\":{\"id\":7870390,\"name\":\"Alberton North\",\"coord\":{\"lat\":-26.241,\"lon\":28.1325},\"country\":\"ZA\",\"timezone\":7200,\"sunrise\":1581047177,\"sunset\":1581094614}}".data(using: String.Encoding.utf8)!
        
        
        let weatherModel = weatherService.parseJSON(newData)
        if weatherModel?.forecastList.count == 0 {
            XCTFail("Valid JSON was not parsed successfully")
            return
        }
        XCTAssertEqual("Alberton North", weatherModel?.cityName)
        XCTAssertEqual(31.51,weatherModel?.temperature)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        measure {
            testParseValidJson()
            // Put the code you want to measure the time of here.
        }
    }
    
}
