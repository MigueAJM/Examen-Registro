//
//  ViewController.swift
//  ExamenII
//
//  Created by Miguel Angel Jimenez Melendez on 3/12/20.
//  Copyright © 2020 Miguel Angel Jimenez Melendez. All rights reserved.
//

import UIKit
import  SQLite3

class ViewController: UIViewController {
    @IBOutlet weak var lbusuario: UILabel!
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
        let query = "Select * From usuario"
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK {
            let error = sqlite3_errmsg(db)
            Alerta(title: "Error", message: "Error en \(error)")
            return
        }
        if sqlite3_step(stmt) == SQLITE_ROW {
            let nombre = String(cString: sqlite3_column_text(stmt, 1))
            
            lbusuario.text = "Hola \(nombre)"
        }else {
            self.performSegue(withIdentifier: "SVRegistro", sender: self)
        }
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SVRegistro" {
            _ = segue.destination as! ViewControllerRegistro
        }
    }
    func Alerta(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

