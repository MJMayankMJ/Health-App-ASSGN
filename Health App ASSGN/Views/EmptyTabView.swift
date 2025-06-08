//
//  EmptyTabView.swift
//  Health App ASSGN
//
//  Created by Mayank Jangid on 6/7/25.
//

import SwiftUI

struct EmptyTabView: View {
    let title: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            
            Text("Coming Soon")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct EmptyTabView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyTabView(title: "Calendar")
    }
}
