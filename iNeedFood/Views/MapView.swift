//
//  MapView.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/5/25.
//  The Map and all locations were done by me, the addition of CoreLocation and the tools to view the user's location were AI generated

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @State private var pos = MapCameraPosition.userLocation(fallback: .automatic)
    @State private var locationManager = LocationManager()
    @State private var showingPermissionAlert: Bool = false
    
    @StateObject private var viewModel = StoreViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.54355928066485,  longitude: -119.81594713282051), //Relative center of UNR
        span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: viewModel.stores) { store in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: store.latitude, longitude: store.longitude)) {
                        NavigationLink(destination: StoreView(storeID: store.id)) {
                            VStack {
                                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                    .foregroundColor(.blue)
                                    .frame(width:45, height: 45)
                                Text(store.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    .padding(.top, -20)
                            }
                        }
                        .navigationTitle("Back to Map")
                        .navigationBarHidden(true)
                    }
                }
                .ignoresSafeArea(.all, edges: .top)
                .mapStyle(.standard(pointsOfInterest: .excludingAll, showsTraffic: false))
                
                LocationButton(locationManager: locationManager, region: $region)
                
                .onAppear {
                    viewModel.fetchAllStores()
                    locationManager.requestPermission()
                }
            }
        }
    }
}

struct LocationButton: View {
    @ObservedObject var locationManager: LocationManager
    @Binding var region: MKCoordinateRegion
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    centerMapOnUser()
                } label: {
                    Image(systemName: "location.fill")
                        .padding()
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                .padding(.trailing, 20)
                .padding(.bottom, 50)
            }
        }
    }
    
    private func centerMapOnUser() {
        if let location = locationManager.lastLocation {
            region.center = location.coordinate
        }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        DispatchQueue.main.async {
                self.lastLocation = locations.last
        }
    }
       
   func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
       switch manager.authorizationStatus {
       case .authorizedWhenInUse, .authorizedAlways:
           manager.startUpdatingLocation()
       default:
           break
       }
   }
}

#Preview {
    MapView()
}
