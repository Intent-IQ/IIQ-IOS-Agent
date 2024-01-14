import Foundation

struct VRResponse: Codable {
    let adt: Int
    let ct: Int
    let data: VRData?
    let dbsaved: Bool
    let ls: Bool
    var cttl: Int64?
    let tc: Int
    let sid: Int
    let pid: String?
    let dea: Int?
    let ekv: String?
    

    init(adt: Int, ct: Int, data: Any?, dbsaved: Bool, ls: Bool, cttl: Int64?, tc: Int, sid: Int, pid: String?, dea: Int?, ekv:String?) {
        self.adt = adt
        self.ct = ct
        self.dbsaved = dbsaved
        self.ls = ls
        self.cttl = cttl
        self.tc = tc
        self.sid = sid
        self.pid = pid
        self.dea = dea
        self.ekv = ekv
        
        guard let unwrappedData = data else {
            self.data = VRData(eids: [])
            return
        }
        
        if let stringData = unwrappedData as? String {
            self.data = VRData(eids: [])
            //TODO: add decoding if needed
        } else {
            if let vrData = data as? VRData {
                   self.data = vrData
                   // Handle other properties if needed
            } else {
                self.data = VRData(eids: [])
            }
        }
       
       
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        adt = try container.decode(Int.self, forKey: .adt)
        ct = try container.decode(Int.self, forKey: .ct)

        // Handle optional VRData
        data = try? container.decode(VRData.self, forKey: .data)

        // Handle "dbsaved" as a string or boolean
        if let dbsavedString = try? container.decode(String.self, forKey: .dbsaved) {
            dbsaved = (dbsavedString.lowercased() == "true")
        } else {
            dbsaved = try container.decode(Bool.self, forKey: .dbsaved)
        }

        ls = try container.decode(Bool.self, forKey: .ls)
        cttl = try? container.decode(Int64.self, forKey: .cttl)
        tc = try container.decode(Int.self, forKey: .tc)
        sid = try container.decode(Int.self, forKey: .sid)
        pid = try? container.decode(String.self, forKey: .pid)
        dea = try? container.decode(Int.self, forKey: .dea)
        ekv = try? container.decode(String.self, forKey: .ekv)
    }

    func prettyPrint() -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch {
            return "Error pretty printing VRResponse: \(error)"
        }
    }
    func extructIIQPrebidIds() -> [IIQPrebidId] {
          var uidInfoArray: [IIQPrebidId] = []
          
        guard let unwrappedData = self.data else {
               return []
           }
        
          for eid in unwrappedData.eids {
              for uid in eid.uids {
                  let uidInfo = IIQPrebidId(source: eid.source, identifier: uid.id, atype: nil, ext: nil)
                  uidInfoArray.append(uidInfo)
              }
          }
          
          return uidInfoArray
      }
}

public struct VRData: Codable {
    let eids: [EID]

    struct EID: Codable {
        let uids: [UID]
        let source: String

        struct UID: Codable {
            let ext: Extension
            let id: String

            struct Extension: Codable {
                let stype: String
            }
        }
    }
    public func prettyPrint() -> String {
          let encoder = JSONEncoder()
          encoder.outputFormatting = .prettyPrinted

          do {
              let data = try encoder.encode(self)
              if let prettyPrintedString = String(data: data, encoding: .utf8) {
                  return prettyPrintedString
              } else {
                  return "Failed to convert data to pretty printed string."
              }
          } catch {
              return "Error encoding data: \(error.localizedDescription)"
          }
      }
}
