//
//  ViewControllerRegistro.swift
//  ExamenII
//
//  Created by Miguel Angel Jimenez Melendez on 3/12/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import SQLite3
class ViewControllerRegistro: UIViewController {
    @IBOutlet weak var txtNcontrol: UITextField!
    @IBOutlet weak var txtnombre: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtpsw: UITextField!
    var db: OpaquePointer?
    var stmt: OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteExamen.sqlite")
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            Alerta(title: "Error", message: "No se creo DB")
            return
        }
        let tableuser = "Create Table If Not Exists usuario(ncontrol Text Primary Key, nombre Text, email Text, password Text)"
        if sqlite3_exec(db, tableuser, nil, nil, nil) != SQLITE_OK {
            Alerta(title: "Error", message: "No se creo Tuser")
            return
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func btnRegistrar(_ sender: UIButton) {
        if txtNcontrol.text!.isEmpty || txtnombre.text!.isEmpty || txtEmail.text!.isEmpty || txtpsw.text!.isEmpty {
            Alerta(title: "Falta Informaciòn", message: "Complete el formulario")
            txtNcontrol.becomeFirstResponder()
        }else {
            let ncontrol = txtNcontrol.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let nombre = txtnombre.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let email = txtEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            let psw = txtpsw.text?.trimmingCharacters(in: .whitespacesAndNewlines) as! NSString
            
            let query = "Insert Into usuario(ncontrol, nombre, email, password) Values(?, ?, ?, ?)"
            if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
                Alerta(title: "Error", message: "No se pued ligar Query")
                return
            }
            if sqlite3_bind_text(stmt, 1, ncontrol.utf8String, -1, nil) != SQLITE_OK {
                Alerta(title: "Error", message: "Error ncontrol")
                return
            }
            if sqlite3_bind_text(stmt, 2, nombre.utf8String, -1, nil) != SQLITE_OK {
               Alerta(title: "Error", message: "Error nombre")
               return
           }
            if sqlite3_bind_text(stmt, 3, email.utf8String, -1, nil) != SQLITE_OK {
               Alerta(title: "Error", message: "Error email")
               return
           }
            if sqlite3_bind_text(stmt, 4, psw.utf8String, -1, nil) != SQLITE_OK {
               Alerta(title: "Error", message: "Error psw")
               return
           }
            
            if sqlite3_step(stmt) != SQLITE_OK {
                self.performSegue(withIdentifier: "SVInicio", sender: self)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SVInicio" {
            _ = segue.destination as! ViewController
        }
    }
    
    func Alerta(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
