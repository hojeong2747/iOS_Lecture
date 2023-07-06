//
//  ViewController.swift
//  AutoLayoutTest
//
//  Created by Dongduk1 on 2023/07/04.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var audioPlayer: AVAudioPlayer!
    var audioFile: URL!
    let MAX_VOLUME: Float = 10.0
    var progressTimer: Timer!
    
    let PICKER_VIEW_COLUMN = 1
    let PICKER_VIEW_HEIGHT:CGFloat = 30
    var musicFileName = ["Sicilian_Breeze", "Gully Dreams - Hanu Dixit", "Malkauns - Aditya Verma"]
    var selectedMusic: String = "Sicilian_Breeze"
    @IBOutlet var pickerMusic: UIPickerView!
    
    let timePlayerSelector:Selector = #selector(ViewController.updatePlayTime)
    
    @IBOutlet var pvProgressPlay: UIProgressView!
    @IBOutlet var lblCurrentTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnPause: UIButton!
    @IBOutlet var btnStop: UIButton!
    
    @IBOutlet var slVolume: UISlider!
    
    @IBOutlet var btnRecord: UIButton!
    @IBOutlet var lblRecordTime: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    var isRecordMode = false
    
    let timeRecordSelector: Selector = #selector(ViewController.updateRecordTime)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        audioFile = Bundle.main.url(forResource: selectedMusic, withExtension: "mp3")
        selectAudioFile(selectedMusic)
        if !isRecordMode {
            initPlay()
            btnRecord.isEnabled = false
            lblRecordTime.isEnabled = false
        } else {
            initPlay()
        }
    }

    @IBAction func btnPlayAudio(_ sender: UIButton) {
        audioPlayer.play()
        setPlayButtons(false, pause: true, stop: true)
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
    
    @objc func updatePlayTime() {
        lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
    }
    
    @IBAction func btnPauseAudio(_ sender: UIButton) {
        audioPlayer.pause()
        setPlayButtons(true, pause: false, stop: true)
    }
    
    @IBAction func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(true, pause: false, stop: false)
        progressTimer.invalidate()
    }
    
    @IBAction func slChangeVolume(_ sender: UISlider) {
        audioPlayer.volume = slVolume.value
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        setPlayButtons(true, pause: false, stop: false)
    }
    
    func initPlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay : \(error)")
        }
        slVolume.maximumValue = MAX_VOLUME
        slVolume.value = 1.0
        pvProgressPlay.progress = 0
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay() // 실제 메모리에 로딩됨
        audioPlayer.volume = slVolume.value
        
        lblEndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        
        setPlayButtons(true, pause: false, stop: false)
        
        btnPlay.isEnabled = true
        btnPause.isEnabled = false
        btnStop.isEnabled = false
    }
    
    func setPlayButtons(_ play: Bool, pause: Bool, stop: Bool) {
        btnPlay.isEnabled = play
        btnPause.isEnabled = pause
        btnStop.isEnabled = stop
    }
    
    // 시간 정보 형식 바꿔서 출력
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        let min = Int(time/60) // 초로 넘겨주기 때문에 나머지 연산
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        let strTime = String(format: "%02d:%02d", min, sec)
        
        return strTime
    }
    
    // 녹음
//    func selectAudioFile() {
//        if !isRecordMode {
//            audioFile = Bundle.main.url(forResource: "Sicilian_Breeze", withExtension: "mp3")
//        } else {
//            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            audioFile = documentDirectory.appendingPathComponent("recordFile.m4a")
//        }
//    }
    func selectAudioFile(_ audio: String) {
        if !isRecordMode {
            audioFile = Bundle.main.url(forResource: audio, withExtension: "mp3")
        } else {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            audioFile = documentDirectory.appendingPathComponent("recordFile.m4a")
        }
    }
    
    // 레코드 모드일 때 초기화
    func initRecord() {
        let recordSettings = [
            AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless as UInt32), AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue, AVEncoderBitRateKey : 320000, AVNumberOfChannelsKey : 2, AVSampleRateKey : 44100.0] as [String : Any]
        do {
            audioRecorder = try AVAudioRecorder(url: audioFile, settings: recordSettings)
        } catch let error as NSError {
            print("Error-initRecord : \(error)")
        }
        
        audioRecorder.delegate = self
        
        slVolume.value = 1.0
        audioPlayer.volume = slVolume.value
        lblEndTime.text = convertNSTimeInterval2String(0)
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(false, pause: false, stop: false)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError {
            print("Error-setCategory : \(error)")
        }
        
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("Error-setActive : \(error)")
        }
    }
    
    @IBAction func swRecordMode(_ sender: UISwitch) {
        if sender.isOn {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            lblRecordTime!.text = convertNSTimeInterval2String(0)
            isRecordMode = true
            btnRecord.isEnabled = true
            lblRecordTime.isEnabled = true
        } else {
            isRecordMode = false
            btnRecord.isEnabled = false
            lblRecordTime.isEnabled = false
            lblRecordTime.text = convertNSTimeInterval2String(0)
        }
        
        selectAudioFile(selectedMusic)
        
        if !isRecordMode {
            initPlay()
        } else {
            initRecord()
        }
    }
    
    @IBAction func btnRecord(_ sender: UIButton) {
        if (sender as AnyObject).titleLabel?.text == "Record" {
            audioRecorder.record()
            (sender as AnyObject).setTitle("Stop", for: UIControl.State())
            
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)
        } else {
            audioRecorder.stop()
            progressTimer.invalidate()
            (sender as AnyObject).setTitle("Record", for: UIControl.State())
            btnPlay.isEnabled = true
            initPlay()
        }
    }
    
    @objc func updateRecordTime() {
        lblRecordTime.text = convertNSTimeInterval2String(audioRecorder.currentTime)
    }
    
    // pickerView
    // 스크롤 되는 게 두 개가 될 수 있다. 몇 칸 표시할 건지 (한 칸으로만 표시)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return PICKER_VIEW_COLUMN
    }
    
    // 배열 개수 반환. 스크롤 옵션 몇 개로 할 건지 (배열 개수만큼 스크롤 옵션)
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return musicFileName.count
    }
    
    // 별도 추가, 배열 요소 값 표시 - row는 몇 번째인지 들어옴. 피커뷰 인덱스 = 배열 인덱스
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return musicFileName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return PICKER_VIEW_HEIGHT
    }
    
    // 별도 추가, 스크롤 이벤트 발생했을 때 호출되는 함수, 딱 멈추면 그 위치에 그림 파일 이름을 가져다가 레이블에 표시
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedMusic = musicFileName[row]
        print(selectedMusic)
        selectAudioFile(selectedMusic)
        initPlay()
    }
    
}
