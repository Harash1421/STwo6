import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    
    //Actions Variables
    @IBOutlet weak var main_tvCountry: UILabel!
    @IBOutlet weak var main_tvToday: UILabel!
    @IBOutlet weak var main_iView: UIImageView!
    @IBOutlet weak var main_wType: UILabel!
    @IBOutlet weak var main_tvWeather: UILabel!
    
    //Location Manager Variables
    var locationManger = CLLocationManager()
    var location = CLLocation()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManger.delegate = self
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        locationManger.requestWhenInUseAuthorization()
        locationManger.startUpdatingLocation()

        //Get Day
        let date = Date()
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEEE"
        let day = dayFormatter.string(from: date)
        self.main_tvToday.text = day
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Latitude And Longitude
        let lat = locations[0].coordinate.latitude
        let lon = locations[0].coordinate.longitude
        
        //Json Coding
        let id = "Your Open Weather Id"
        let url = URL(string:"http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(id)&units=metric")
        let urlSession = URLSession.shared
        //Json Code
        let task = urlSession.dataTask(with: url!) { data, respone, error in
            if(error != nil){
                let alert = UIAlertController(title: "Error!", message: error?.localizedDescription, preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }else{
                if (data != nil){
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any>
                            DispatchQueue.main.async {
                                if let main = json["main"] as? [String:Any]{
                                    if let temp = main["temp"] as? Double{
                                        self.main_tvWeather.text = "\(Int(temp))°C"
                                    }
                                    if let weather = json["weather"] as? [[String:Any]]{
                                        for weathers in weather{
                                            if let description = weathers["description"] as? String{
                                                self.main_wType.text = description.capitalized
                                            }
                                            if let icon = weathers["icon"] as? String{
                                                self.main_iView.image = UIImage(named: icon)
                                            }
                                        }
                                    }
                                    if let nameCountry = json["name"] as? String{
                                        self.main_tvCountry.text = String(nameCountry)
                                    }
                                }
                                
                            }
                        }catch{
                            print("Error!")
                        }
                }
            }
        }
        task.resume()
        locationManger.stopUpdatingLocation()
    }
    func getWeather(){
        
    }
}

