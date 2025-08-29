//
//  ViewController.swift
//  Simple
//
//  Created by Himanshu vyas on 27/08/25.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableV: UITableView?
    @IBOutlet weak var chatV: UIView?
    @IBOutlet weak var chatField: UITextField?
    @IBOutlet weak var senderBtn: UIButton?
    
    private var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableV?.separatorStyle = .none
        tableV?.rowHeight = UITableView.automaticDimension
        tableV?.estimatedRowHeight = 44
        tableV?.register(ChatBubbleCell.self, forCellReuseIdentifier: "ChatBubbleCell")
        //messages.append(Message(isUser: true, type: .text("Hello!")))
        messages.append(Message(isUser: false, type: .text("Hi 👋, How may I help you?")))
        setupchatView()
    }
    
    func setupchatView(){
        self.chatV?.layer.cornerRadius = 25
        self.chatField?.placeholder = "Type Here..."
    }
    
    @IBAction func senderAction(_ sender: UIButton) {
        guard let text = chatField?.text, !text.isEmpty else { return }
        chatField?.resignFirstResponder()
        senderBtn?.isEnabled = false
        senderBtn?.alpha = 0.5
        
        // Show user message
        addMessage(Message(isUser: true, type: .text(text)))
        chatField?.text = ""
        
        // Show typing indicator
        let typingMessage = Message(isUser: false, type: .typing)
        addMessage(typingMessage)
        
        Task {
            do {
                let replies = try await APIService.shared.sendMessage(text)
                
                // Remove typing bubble before showing reply
                removeTypingIndicator()
                // ✅ Append all messages from the reply
                       for reply in replies {
                           addMessage(reply)
                       }
                
            } catch {
                removeTypingIndicator()
                addMessage(Message(isUser: false, type: .text("❌ Error: \(error.localizedDescription)")))
            }
            
            senderBtn?.isEnabled = true
            senderBtn?.alpha = 1.0
        }
    }
    
    func removeTypingIndicator() {
        if let index = messages.lastIndex(where: {
            if case .typing = $0.type { return true }
            return false
        }) {
            messages.remove(at: index)
            DispatchQueue.main.async {
                self.tableV?.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatBubbleCell", for: indexPath) as? ChatBubbleCell else {
            return UITableViewCell()
        }
        cell.configure(with: messages[indexPath.row])
        return cell
    }
    
    // MARK: - Add new messages
    func addMessage(_ message: Message) {
        messages.append(message)
        tableV?.reloadData()
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableV?.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

 
