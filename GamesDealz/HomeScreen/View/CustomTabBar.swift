//
//  CustomTabBar.swift
//  GamesDealz
//
//  Created by Daniil Balakiriev on 09.05.2025.
//

import SwiftUI

public enum CustomTabViewElements: CaseIterable, Equatable {
  case deals
  case games
}

private extension CustomTabViewElements {
  var title: String {
    switch self {
    case .deals: return "Deals"
    case .games: return "Games"
    }
  }
  
  var iconName: String {
    switch self {
    case .deals: return "tag.fill"
    case .games: return "gamecontroller.fill"
    }
  }
}

public struct CustomTabBar: View {
  @Binding public var selection: CustomTabViewElements

  public init(selection: Binding<CustomTabViewElements>) {
    _selection = selection
  }

  public var body: some View {
    HStack {
      ForEach(CustomTabViewElements.allCases, id: \.self) { tab in
        Button {
          selection = tab
        } label: {
          VStack(spacing: 4) {
            Image(systemName: tab.iconName)
              .font(.system(size: 20))
            Text(tab.title)
              .font(.caption)
          }
          .foregroundColor(selection == tab
                            ? Color.blue
                            : Color(UIColor.systemGray))
          .frame(maxWidth: .infinity)
        }
      }
    }
    .padding(.vertical, 8)
    .background(Color(UIColor.systemBackground))
  }
}

#Preview {
    CustomTabBar(selection: .constant(.deals))
    CustomTabBar(selection: .constant(.games))
}
