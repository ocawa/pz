/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

class PlayersViewController: UITableViewController {
  
  var players:[Player] = playersData
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return players.count
  }
  
    // ADD IBACTION FOR THE SYNC BUTTON HERE.
    @IBAction func Sync(sender: UIButton) {
        
        let alert:UIAlertController
        let okayButton = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        var isSent:Bool = true
        
        //client.send(str: message)
        var str:String = ""
        var alldates:String = ""
        for everyData in players{
             // small parser... converting mo, tu... m,t...
         alldates = ""
            if(everyData.game!.rangeOfString("Su") != nil){
                alldates = appendHelper(alldates, str2: "0") //
            }
            if(everyData.game!.rangeOfString("Mo") != nil){
                alldates = appendHelper(alldates, str2: "1")
            }
            if(everyData.game?.rangeOfString("Tu") != nil){
                alldates = appendHelper(alldates, str2: "2")
            }
            if(everyData.game?.rangeOfString("We") != nil){
                alldates = appendHelper(alldates, str2: "3")
            }
            if(everyData.game?.rangeOfString("Th") != nil){
                alldates = appendHelper(alldates, str2: "4")
            }
            if(everyData.game?.rangeOfString("Fr") != nil){
                alldates = appendHelper(alldates, str2: "5")
            }
            if(everyData.game?.rangeOfString("Sa") != nil){
                alldates = appendHelper(alldates, str2: "6")
            }
            
            str = "SCHED \(alldates) \(everyData.name!) \(String(Int(everyData.pos)))"
            print(str)
    //  print("To Send: \(str)")
            // send wifi
            if(serial.isConnected()){
                if let bleService = serial.bleService {
                    bleService.sendMessageToDevice(str)
                    
                }
            }
            else if(client.isConnected()){
        client.send(str: str)
            }
            else{
                isSent = false
                print("To Send: \(str)")
            }
        }
    
        var title:String?
        if(isSent){
      title = "Success"
        }
        else{
            title = "Failed"
        }
      alert = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(okayButton)
        presentViewController(alert, animated: true, completion: nil)

        
    }
    
    func appendHelper(str1:String, str2:String) -> String{
    return str1 + str2
    }
    
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
    -> UITableViewCell {
        /*
         THIS IS THE SCENE WHERE AUTOMATIONS ARE LOADED AND DISPLAYED IN THE VIEW.
         NOTE: WHEN ADDING A NEW INSTANCE... IT WILL CALL THIS FUNCTION TO RELOAD THE NEW DATA. THEREFORE,
         YOU MUST ADD THE NEW DATA TO THE PLIST.. OR IT WONT LOAD HERE.
         
         THINGS TO DO HERE:
         1) LOAD DATA FROM PLIST THEN ASSIGN IT TO players VARIABLE
         
         */
      let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)
        as! PlayerCell
      let player = players[indexPath.row] as Player
      cell.player = player
      return cell
  }
  
  // Mark Unwind Segues
  @IBAction func cancelToPlayersViewController(segue:UIStoryboardSegue) {
  }
  
  @IBAction func savePlayerDetail(segue:UIStoryboardSegue) {
    
    //print("b")
    if let playerDetailsViewController = segue.sourceViewController as? PlayerDetailsViewController {
      
      //add the new player to the players array
      if let player = playerDetailsViewController.player {
        players.append(player)
        
        //update the tableView
        let indexPath = NSIndexPath(forRow: players.count-1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
      }
    }
  }
}
