//
//  PageView.swift
//  iTrackAlpha
//
//  Created by Amanda Beger on 2/12/23.
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]

    var body: some View {
        PageViewController(pages: pages)
    }
}

struct PageView_Previews: PreviewProvider {
    // var pageArray: [Page] = [ContentView()]
    static private var tempvm = ViewModel()
    static private var tempCust = CustomizationObject()
    static var previews: some View {
        PageView(pages: [ContentView(viewModel: tempvm, lastAction: "none", customizations: tempCust)])
    }
}
