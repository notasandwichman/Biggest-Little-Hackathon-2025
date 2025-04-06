//
//  StoreMapView.swift
//  iNeedFood
//
//  Created by Henry Dalton on 4/6/25.
//

import SwiftUI
import MapKit

struct StoreMapView: View {
    
    let storeID: Int
    
    @StateObject private var viewModel = StoreViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        VStack {
            if let store = viewModel.store {
                Map(
                coordinateRegion: $region,
                showsUserLocation: true,
                annotationItems: [store])
                { store in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(
                        latitude: store.latitude,
                        longitude: store.longitude)) {
                            VStack {
                                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 45, height: 45)
                                Text(store.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                }
                .ignoresSafeArea(.all)
                .mapStyle(.standard(pointsOfInterest: .excludingAll))
                .onAppear{
                    region.center = CLLocationCoordinate2D(
                        latitude: store.latitude,
                        longitude: store.longitude)
                }
            }
        }
        .onAppear {
            viewModel.fetchStore(by: storeID)
        }
    }
}

#Preview {
    StoreMapView(storeID: 1)
}
