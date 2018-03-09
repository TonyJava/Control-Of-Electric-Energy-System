
import Foundation

struct Page {
    let title: String
    let message: String
    let imageName: String
}

let pages:[Page] = {
    let firstPage = Page(title: "인절미는?", message: "공공기관 내 낭비되는 전기를 제어하는 애플리케이션입니다.", imageName: "page1")
    let secondPage = Page(title: "한눈에 보기 좋은 UI/UX로", message: "각 건물별로 낭비되는 전기를 체크할 수 있습니다", imageName: "page2")
    let thirdPage = Page(title: "강의실", message: "건물별 강의실 마다 현재 소비되는 전력을 체크하고 제어할 수 있습니다.", imageName: "page3")
    let fourthPage = Page(title: "지금바로!", message: "학교의 낭비되는 전력을 체크하고 제어해보세요!", imageName: "page3")
    return [firstPage, secondPage, thirdPage, fourthPage]
}()

struct Building {
    let image: String
    let name : String
}

let buildings:[Building] = {
    let building00 = Building(image: "btn_building00", name: "1")
    let building01 = Building(image: "btn_building01", name: "2")
    let building02 = Building(image: "btn_building02", name: "3")
    let building03 = Building(image: "btn_building03", name: "4")
    let building04 = Building(image: "btn_building04", name: "5")
    let building05 = Building(image: "btn_building05", name: "6")
    let building06 = Building(image: "btn_building06", name: "7")
    let building07 = Building(image: "btn_building07", name: "8")
    let building08 = Building(image: "btn_building08", name: "9")
    return [building00, building01, building02, building03, building04, building05, building06, building07, building08]
}()

struct Room {
    let image: String
    let number: Int
}

let rooms:[Room] = {
    let room01 = Room(image: "bg_room_00", number: 1)
    let room02 = Room(image: "bg_room_01", number: 2)
    let room03 = Room(image: "bg_room_02", number: 3)
    let room04 = Room(image: "bg_room_03", number: 4)
    let room05 = Room(image: "bg_room_04", number: 5)
    let room06 = Room(image: "bg_room_05", number: 6)
    let room07 = Room(image: "bg_room_06", number: 7)
    let room08 = Room(image: "bg_room_07", number: 8)
    let room09 = Room(image: "bg_room_08", number: 9)
    return [room01, room02, room03, room04, room05, room06, room07, room08, room09]
}()

var adminLoadData:[[String: String]] = [[:]]
var adminlevelData = [String]()
var adminUseridData = [String]()

var shutdownLocationData = [String]()
var shutdownTotalData = [String]()
var shutdownOncountData = [String]()


