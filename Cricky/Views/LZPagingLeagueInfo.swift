//
//  LZPagingLeagueInfo.swift
//  Cricky
//
//  Created by bjit on 23/2/23.
//

import LZViewPager
import UIKit

class LZPagingLeagueInfo: UIViewController, LZViewPagerDelegate, LZViewPagerDataSource {
    @IBOutlet var viewPager: LZViewPager!
    private var subControllers: [UIViewController] = []
    var essentialData: (String, Int)?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewPagerProperties()
    }

    func viewPagerProperties() {
        viewPager.delegate = self
        viewPager.dataSource = self
        viewPager.hostController = self

        let vc1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeagueStandingVC") as! LeagueStandingVC

        let vc2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Matches") as! Matches
        let vc3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeagueSummaryVC") as! LeagueSummaryVC

        vc1.viewModel.requestApi(seasonId: essentialData!.1)
        vc2.passedLink = essentialData!.0
        vc3.viewModel.getMatchData(season: essentialData!.1)

        vc1.loadViewIfNeeded()
        vc2.loadViewIfNeeded()
        vc3.loadViewIfNeeded()

        vc1.title = "Standing"
        vc2.title = "Fixtures"
        vc3.title = "Insights"

        subControllers = [vc1, vc2, vc3]
        viewPager.reload()
    }

    // MARK: Action

    func numberOfItems() -> Int {
        subControllers.count
    }

    func controller(at index: Int) -> UIViewController {
        return subControllers[index]
    }

    func button(at _: Int) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = #colorLiteral(red: 0.2065195143, green: 0.2087805867, blue: 0.34461537, alpha: 1)
        return button
    }
}
