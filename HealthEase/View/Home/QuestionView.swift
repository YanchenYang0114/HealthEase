//
//  QuestionView.swift
//
//  Created by Yang on on 1/3/2025.
//

import SwiftUI


struct NavBarQuestionViewModifier: ViewModifier{
    @Binding  var showAlert: Bool
    func body(content: Content) -> some View {
        content.toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAlert.toggle()
                } label: {
                    Image("icon_question")
                }

            }
        })
    }
}
struct NavBarQuestionViewModifier2: ViewModifier{
    @Binding  var showAlert: Bool
    func body(content: Content) -> some View {
        content.toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAlert.toggle()
                } label: {
                    Image("icon_question")
                }

            }
        })
    }
}
