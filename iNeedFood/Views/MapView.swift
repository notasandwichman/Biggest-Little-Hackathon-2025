//
//  MapView.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/5/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = StoreViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.54371380605513, longitude: -119.8154357161432), //Relative center of UNR
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var body: some View {
        NavigationView {
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
                        }
                    }
                }
            }
            .ignoresSafeArea(.all)
            .mapStyle(.standard(pointsOfInterest: .excludingAll))
            .onAppear {
                viewModel.fetchAllStores()
            }
        }
    }
}

#Preview {
    MapView()
}
