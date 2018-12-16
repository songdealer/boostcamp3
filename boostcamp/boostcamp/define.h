//
//  BarSize.h
//  boostcamp
//
//  Created by user on 12/12/2018.
//  Copyright © 2018 user. All rights reserved.
//

#ifndef define_h
#define define_h
#define __baseURL @"http://connect-boxoffice.run.goorm.io"
#define __moviesURL @"/movies"
#define __movieURL @"/movie"
#define __commentsURL @"/comments"

#define __NavigationBarFrame self.navigationController.navigationBar.frame
#define __ViewStartOrigin (__NavigationBarFrame.origin.y + __NavigationBarFrame.size.height)
#define __ViewEndOrigin self.tabBarController.tabBar.frame.origin.y
#define __scViewEndOrigin self.view.frame.size.height

#define __ViewWidth self.view.frame.size.width
#define __ViewHeight (__ViewEndOrigin - __ViewStartOrigin)
#define __scViewHeight (__scViewEndOrigin - __ViewStartOrigin)

#pragma mark - tableView
#define __tableCellHeight __ViewHeight * 0.2
#define __tableCellImgLeftMargin 10
#define __tableCellImgWidth __ViewWidth * 0.2
#define __tableCellTextMargin 10
#define __tableCellTitleLeftMargin (__tableCellImgLeftMargin + __tableCellImgWidth + __tableCellTextMargin)
#define __tableCellLabelWidth (__ViewWidth - __tableCellTitleLeftMargin)
#define __tableCellLabelHeight __tableCellHeight * 0.25
#define __tableCellSubTitleTopMargin (__tableCellTextMargin * 2 + __tableCellLabelHeight)
#define __tableCellDateTopMargin (__tableCellTextMargin * 3 + __tableCellLabelHeight * 2)

#pragma mark - collectionView
#define __collectionCellWidth __ViewWidth * 0.5
#define __collectionCellHeight __ViewHeight * 0.6
#define __collectionCellViewMargin 10
#define __collectionCellViewWidth (__collectionCellWidth - __collectionCellViewMargin * 2)
#define __collectionCellImgHeight __collectionCellHeight * 0.7
#define __collectionCellLabelHeight (__collectionCellHeight - (__collectionCellViewMargin * 5 + __collectionCellImgHeight)) / 3
#define __collectionCellTitleTopMargin (__collectionCellViewMargin * 2 + __collectionCellImgHeight)
#define __collectionCellSubTitleTopMargin (__collectionCellTitleTopMargin + __collectionCellLabelHeight + __collectionCellViewMargin)
#define __collectionCellDateTopMargin (__collectionCellSubTitleTopMargin + __collectionCellLabelHeight + __collectionCellViewMargin)

#pragma mark - movieView
#define __imageViewWidth __ViewWidth * 0.34
#define __imageViewHeight __scViewHeight * 0.25
#define __topLabelX (__imageViewWidth + __tableCellImgLeftMargin * 2)
#define __topTitleCenter (__imageViewHeight + __tableCellImgLeftMargin) * 0.5
#define __topLabelWidth (__ViewWidth - __imageViewWidth - __tableCellImgLeftMargin * 2)
#define __topLabelHeight __imageViewHeight * 0.25

#define __titleCellFontSize 18
#define __subTitleCellFontSize 16
#define __dateCellFontSize 14
#endif /* define_h */
