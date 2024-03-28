import UIKit

class TimerViewController: UIViewController {

    var timer: Timer?
    var remainingTime: Int = 0
    var cookingTime: Int = 0
    var isTimerRunning = false

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startPauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timerValue: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateTimeLabel()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        isTimerRunning = true
    }

    func pauseTimer() {
        timer?.invalidate()
        isTimerRunning = false
    }

    func resumeTimer() {
        startTimer()
    }

    func stopTimer() {
        timer?.invalidate()
        isTimerRunning = false
        remainingTime = 0
        updateTimeLabel()
        startPauseButton.setTitle("Start", for: .normal)
    }

    func resetTimer() {
        stopTimer()
        remainingTime = cookingTime * 60
        updateTimeLabel()
    }

    @objc func updateTimer() {
        remainingTime -= 1
        updateTimeLabel()
        if remainingTime <= 0 {
            stopTimer()
            showAlert()
        }
    }

    func updateTimeLabel() {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        timeLabel.text = String(format: "Time Left - %02d:%02d Minutes", minutes, seconds)
    }

    func showAlert() {
        let alertController = UIAlertController(title: "Cooking Timer Finished", message: "Your timer has finished! What would you like to do next?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func startPauseButtonTapped(_ sender: UIButton) {
        if isTimerRunning {
            pauseTimer()
            startPauseButton.setTitle("Resume", for: .normal)
        } else {
            if remainingTime == 0 {
                guard let cookingTimeText = timerValue.text, let cookingTimeValue = Int(cookingTimeText), cookingTimeValue > 0 else {
                    print("Invalid cooking time")
                    return
                }
                cookingTime = cookingTimeValue
                remainingTime = cookingTime * 60
                updateTimeLabel()
            }
            startTimer()
            startPauseButton.setTitle("Pause", for: .normal)
        }
    }

    @IBAction func stopButtonTapped(_ sender: UIButton) {
        stopTimer()
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        resetTimer()
    }

    @IBAction func resumeButtonTapped(_ sender: UIButton) {
        resumeTimer()
        startPauseButton.setTitle("Pause", for: .normal)
    }
}
