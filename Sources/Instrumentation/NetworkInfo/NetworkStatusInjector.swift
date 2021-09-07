// Copyright © 2021 Elasticsearch BV
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

#if os(iOS)
import Foundation
import OpenTelemetryApi
import CoreTelephony
import Network
public class NetworkStatusInjector {
    private var netstat : NetworkStatus
    
    public init(netstat: NetworkStatus) {
        self.netstat = netstat
    }
    
    public func inject(span: Span) {
        let (type, subtype, carrier) = netstat.status()
        span.setAttribute(key: "net.host.connection.type", value:AttributeValue.string(type))

        if let subtype : String  = subtype {
            span.setAttribute(key: "net.host.connection.subtype", value: AttributeValue.string(subtype))
        }

        if let carrierInfo : CTCarrier = carrier {

            if let carrierName = carrierInfo.carrierName {
                span.setAttribute(key: "net.host.carrier.name", value: AttributeValue.string(carrierName))
            }
            
            if let isoCountryCode = carrierInfo.isoCountryCode {
                span.setAttribute(key: "net.host.carrier.icc", value: AttributeValue.string(isoCountryCode))
            }
            
            if let mobileCountryCode = carrierInfo.mobileCountryCode {
                span.setAttribute(key: "net.host.carrier.mcc", value: AttributeValue.string(mobileCountryCode))
            }
            
            if let mobileNetworkCode = carrierInfo.mobileNetworkCode {
                span.setAttribute(key: "net.host.carrier.mnc", value: AttributeValue.string(mobileNetworkCode))
            }
        }
    }
}
#endif
