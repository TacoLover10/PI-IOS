//
//  UniverVerTicketsViewController.swift
//  Rebuc Avalos
//
//  Created by 7k on 31/10/17.
//  Copyright © 2017 7k. All rights reserved.
//

import UIKit
import SQLite

class UniverVerTicketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var ticketsTableView: UITableView!
    
    //Tabla de sesion activa
    var database: Connection!
    let sesionTabla = Table("Sesion")
    let idUsuarioSesExp = Expression<Int>("id_usuario")
    
    //tabla de tickets
    let ticketsTabla = Table("Tickets")
    let idTicketExp = Expression<Int>("id_ticket")
    let idUsuarioExp = Expression<Int>("id_usuario")
  
    let fechaTicketExp = Expression<String>("fecha_ticket")
    let consultaExp = Expression<String>("consulta")
    let estatusExp = Expression<String>("estatus")
    let calificacionesExp = Expression<Int>("calificacion")
    
    //Variables a Utilizar
    var idUsuario: Int!
    var idTicket: Int!
    var descripcion : String!
    var idTickets = [Int]()
    var consultas = [String]()
    var estatus = [String]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //Obtener la ruta del usuario
        do  {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true )
            let fileUrl = documentDirectory.appendingPathComponent("usuarios").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        }
        catch {
            print(error)
        }
        
        //obtener id del usuario que inicio sesion
        do {
            let usuarios =  try self.database.prepare(self.sesionTabla)
            for usuario in usuarios {
                self.idUsuario = usuario[self.idUsuarioSesExp]
                print("el id dek usuarii es: \(self.idUsuario)")
            }
        } catch {
            print(error)
        }
        
        //Obtener los datos de cada ticket y guardalos en arreglos
        do{
            let tickets = self.ticketsTabla.filter(self.idUsuarioExp == idUsuario!)
            for ticket in try database.prepare(tickets) {
                self.idTickets.append(ticket[self.idTicketExp])
                self.consultas.append(ticket[self.consultaExp])
                self.estatus.append(ticket[self.estatusExp])
            }
        }catch {
            print(error)
        }
        
    }
    
    //MARK table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return idTickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = consultas[indexPath.row]
        cell.detailTextLabel?.text=estatus[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print("Seleccionaste el ticket numero \(idTickets[indexPath.row])")
        self.idTicket = idTickets[indexPath.row]
        self.descripcion = consultas[indexPath.row]
        self.performSegue(withIdentifier: "universitarioTicketSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "universitarioTicketSegue" {
            let vc : UniverComentarTicketsViewController = segue.destination as! UniverComentarTicketsViewController
            vc.idUsuario = self.idUsuario
            vc.idTicket = self.idTicket
            vc.descripcion = self.descripcion
        }
    }
    
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
