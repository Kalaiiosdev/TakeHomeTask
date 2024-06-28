import UIKit

class NotesTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    static let identifier = "NotesTableViewCell"
    
    weak var delegate: NotesTableViewCellDelegate?
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var queryField: UITextField!
    
    static func nib() -> UINib {
        return UINib(nibName: "NotesTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        queryField.delegate = self // Set the delegate here
        setupQueryField()
        setupBorder()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        delegate?.didUpdateNotes(self, notes: queryField.text ?? "")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when the return key is pressed
        textField.resignFirstResponder()
        return true
    }
    
    func configure(with notes: String) {
        self.queryField.text = notes
    }
    
    private func setupQueryField() {
        // Adding border to the text field
        queryField.layer.borderColor = UIColor.gray.cgColor
        queryField.layer.borderWidth = 0.5
        queryField.layer.cornerRadius = 5.0 
    }
    private func setupBorder() {
        // Adding border to the text field
        parentView.layer.borderColor = UIColor.gray.cgColor
        parentView.layer.borderWidth = 1.0
        
    }
}
