//
//  ViewController.swift
//  RockPaperScissorsGame
//
//  Created by 유현재 on 05/04/2020.
//  Copyright © 2020 유현재. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    /// Enum Properties
    
    enum ResultState: String {
        case win = "win"
        case draw = "draw"
        case lose = "lose"
    }
    
    enum SRPState {
        case scissors
        case rock
        case paper
        
        var num: Int {
            switch self {
            case .scissors: return 0
            case .rock: return 1
            case .paper: return 2
            }
        }
    }
    
    /// IBOutlet Properties
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultDescriptionLabel: UILabel!
    @IBOutlet weak var scissors: UIButton!
    @IBOutlet weak var rock: UIButton!
    @IBOutlet weak var paper: UIButton!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var stageTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    
    /// Properties
    
    var winCount = 0
    var loseCount = 0
    var stage: Int = 0
    
    /// Override Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
    }
    
    private func initView() {
        self.stageTextField.delegate = self
    }
    
    /// IBAction Methods
    
    @IBAction func didTappedScissors(_ sender: UIButton) {
        self.startProcessing(.scissors)
    }
    
    @IBAction func didTappedRock(_ sender: UIButton) {
        self.startProcessing(.rock)
    }
    
    @IBAction func didTappedPaper(_ sender: UIButton) {
        self.startProcessing(.paper)
    }
    
    @IBAction func didTappedStartButton(_ sender: UIButton) {
        self.gameStart()
    }
}

/// MARK:- Process

extension ViewController {
    
    /// 결과 출력
    ///
    /// Parameters:
    /// input - 입력한 데이터 값
    private func startProcessing(_ input: SRPState) {
        guard let computerOutput = self.computingState() else {
            print("return value is nil")
            return
        }
        switch input {
        case .scissors:
            switch computerOutput {
            case .scissors: self.resultDescriptionLabel.text = ResultState.draw.rawValue
            case .rock:
                self.resultDescriptionLabel.text = ResultState.lose.rawValue
                self.loseCount += 1
            case .paper:
                self.resultDescriptionLabel.text = ResultState.win.rawValue
                self.winCount += 1
            }
        case .rock:
            switch computerOutput {
            case .scissors:
                self.resultDescriptionLabel.text = ResultState.win.rawValue
                self.winCount += 1
            case .rock: self.resultDescriptionLabel.text = ResultState.draw.rawValue
            case .paper:
                self.resultDescriptionLabel.text = ResultState.lose.rawValue
                self.loseCount += 1
            }
        case .paper:
            switch computerOutput {
            case .scissors:
                self.resultDescriptionLabel.text = ResultState.lose.rawValue
                self.loseCount += 1
            case .rock:
                self.resultDescriptionLabel.text = ResultState.win.rawValue
                self.winCount += 1
            case .paper: self.resultDescriptionLabel.text = ResultState.draw.rawValue
            }
        }
        self.stopAnimation()
        self.stageCount()
    }
    
    /// 컴퓨터의 결과 처리
    ///
    private func computingState() -> SRPState? {
        let computingValue = Int.random(in: 0...2)
        switch computingValue {
        case SRPState.scissors.num:
            self.resultImageView.image = UIImage(named: "scissors")
            return .scissors
        case SRPState.rock.num:
            self.resultImageView.image = UIImage(named: "rock")
            return .rock
        case SRPState.paper.num:
            self.resultImageView.image = UIImage(named: "paper")
            return .paper
        default:
            return nil
        }
    }
    
    /// 판 수 설정
    ///
    private func stageCount() {
        if self.winCount > self.stage / 2 {
            self.coverView.isHidden = false
            self.logoImageView.image = UIImage(named: "win")
        } else if self.loseCount > self.stage / 2 {
            self.coverView.isHidden = false
            self.logoImageView.image = UIImage(named: "lose")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.startAnimation()
        }
    }
    
    /// 게임 시작
    ///
    private func gameStart() {
        guard let textField = self.stageTextField.text, !textField.isEmpty else {
            let alert = UIAlertController(title: "", message: "판 수를 설정해 주십시오!", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.coverView.isHidden = true
        self.stage = Int(textField) ?? 0
        self.winCount = 0
        self.loseCount = 0
        self.startAnimation()
    }
    
    /// 애니메이션 시작
    ///
    private func startAnimation() {
        self.resultDescriptionLabel.isHidden = true
        self.resultImageView.animationImages = [UIImage(named: "scissors")!,
                                                UIImage(named: "rock")!,
                                                UIImage(named: "paper")!]
        self.resultImageView.animationDuration = 0.5
        self.resultImageView.startAnimating()
    }
    
    /// 애니메이션 스탑
    ///
    private func stopAnimation() {
        self.resultDescriptionLabel.isHidden = false
        self.resultImageView.stopAnimating()
    }
}

/// MARK:- UITextField Delegate

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

