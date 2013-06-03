//                                
// Copyright 2011 ESCOZ Inc  - http://escoz.com
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import <objc/runtime.h>
#import <QuickDialog.h>
#import "SampleDataBuilder.h"
#import "QDynamicDataSection.h"
//#import "PeriodPickerValueParser.h"



@implementation BasicDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"添加新债";
	QSection *section = [[QSection alloc] init];
    [section addElement:[[QEntryElement alloc] initWithTitle:@"债券简称" Value:nil Placeholder:@""]];

    NSArray *types = @[@"A", @"B"];
    [section addElement: [[QPickerElement alloc] initWithTitle:@"债券类型" items:@[types] value:nil]];
    
    NSArray *kinds = @[@"a", @"b"];
    [section addElement: [[QPickerElement alloc] initWithTitle:@"企业性质" items:@[kinds] value:nil]];
    
    NSArray *Areas = @[@"1", @"2"];
    [section addElement: [[QPickerElement alloc] initWithTitle:@"所在地区" items:@[Areas] value:nil]];
    
    QEntryElement *scale = [[QEntryElement alloc] initWithTitle:@"发行规模" Value:nil Placeholder:@"亿元"];
    scale.keyboardType = UIKeyboardTypeNumberPad;
    scale.prefix = @"(￥亿元)";
    [section addElement:scale];

    QEntryElement *years = [[QEntryElement alloc] initWithTitle:@"发行期限" Value:nil Placeholder:@"年"];
    years.keyboardType = UIKeyboardTypeNumberPad;
    years.prefix = @"(年)";
    years.keyboardType = UIKeyboardTypeNumberPad;
    [section addElement:years];
    
    [root addSection:section];

    QSection *section2 = [[QSection alloc] init];
    NSArray *interest_start = @[@"1%", @"2%", @"3%", @"4%", @"5%", @"6%", @"7%", @"8%", @"9%", @"10%", @"11%", @"12%"];
    NSArray *interest_end = @[@"5%", @"6%", @"7%", @"8%", @"9%", @"10%", @"11%", @"12%", @"13%", @"14%", @"15%", @"16%", @"17%", @"18%", @"19%", @"20%"];
    QPickerElement *interest = [[QPickerElement alloc] initWithTitle:@"利率区间" items:@[interest_start, interest_end] value:@"1%\t8%"];
    interest.prefix = @"(%)";
    [section2 addElement:interest];
    
    QDateTimeInlineElement  *start = [[QDateTimeInlineElement alloc] initWithTitle:@"询价有效期止" date:[NSDate date] andMode:UIDatePickerModeDate];
    [section2 addElement:start];
    
    QDateTimeInlineElement  *end = [[QDateTimeInlineElement alloc] initWithTitle:@"询价有效期止" date:[NSDate date] andMode:UIDatePickerModeDate];
    [section2 addElement:end];
 
    NSArray *item_rates = @[@"AAA", @"AA+", @"AA"];
    QPickerElement *item_rate = [[QPickerElement alloc] initWithTitle:@"债项评级" items:@[item_rates] value:@""];
    [section2 addElement:item_rate];
    
    NSArray *main_rates = @[@"AAA", @"AA+", @"AA"];
    QPickerElement *main_rate = [[QPickerElement alloc] initWithTitle:@"主体评级" items:@[main_rates] value:@""];
    [section2 addElement:main_rate];
    
    QLabelElement *trust_ways = [[QLabelElement alloc] initWithTitle:@"增信方式" Value:nil];
    trust_ways.controllerAction = @"showTrustWays:";
    [section2 addElement:trust_ways];
    
    [section2 addElement:[[QEntryElement alloc] initWithTitle:@"主承销商" Value:nil Placeholder:@""]];

    [root addSection:section2];

    return root;
}

@end

@implementation FinanceDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    
    QSection *section2 = [[QSection alloc] init];
    QEntryElement *total_assets  = [[QEntryElement alloc] initWithTitle:@"总资产" Value:nil Placeholder:@"万元"];
    total_assets.keyboardType = UIKeyboardTypeNumberPad;
    total_assets.prefix = @"(万元)";
    [section2 addElement:total_assets];
    
    QEntryElement *net_assets  = [[QEntryElement alloc] initWithTitle:@"净资产" Value:nil Placeholder:@"万元"];
    net_assets.keyboardType = UIKeyboardTypeNumberPad;
    net_assets.prefix = @"(万元)";
    [section2 addElement:net_assets];
    
    QEntryElement *debt_atio  = [[QEntryElement alloc] initWithTitle:@"资产负债率" Value:nil Placeholder:@"%"];
    debt_atio.keyboardType = UIKeyboardTypeNumberPad;
    debt_atio.prefix = @"(%)";
    [section2 addElement:debt_atio];
    
    NSArray *debts = @[@"长期", @"短期"];
    QPickerElement *debt = [[QPickerElement alloc] initWithTitle:@"有息债务" items:@[debts] value:@""];
    [section2 addElement:debt];
    
    QEntryElement *income  = [[QEntryElement alloc] initWithTitle:@"营业收入" Value:nil Placeholder:@"万元"];
    income.prefix = @"(万元)";
    income.keyboardType = UIKeyboardTypeNumberPad;
    [section2 addElement:income];
    
    QEntryElement *gross_profit_rate  = [[QEntryElement alloc] initWithTitle:@"毛利率" Value:nil Placeholder:@"%"];
    gross_profit_rate.keyboardType = UIKeyboardTypeNumberPad;
    gross_profit_rate.prefix = @"(%)";
    [section2 addElement:gross_profit_rate];
    
    QEntryElement *net_profit_rate  = [[QEntryElement alloc] initWithTitle:@"净利率" Value:nil Placeholder:@"万元"];
    net_profit_rate.keyboardType = UIKeyboardTypeNumberPad;
    net_profit_rate.prefix = @"(万元)";
    [section2 addElement:net_profit_rate];
    
    QEntryElement *cashf_low  = [[QEntryElement alloc] initWithTitle:@"经营性现金流" Value:nil Placeholder:@"万元"];
    cashf_low.prefix = @"(万元)";
    cashf_low.keyboardType = UIKeyboardTypeNumberPad;
    [section2 addElement:cashf_low];
    
    QEntryElement *current_ratio  = [[QEntryElement alloc] initWithTitle:@"流动比率" Value:nil Placeholder:@"%"];
    current_ratio.prefix = @"(%)";
    current_ratio.keyboardType = UIKeyboardTypeNumberPad;
    [section2 addElement:current_ratio];
    
    QEntryElement *ebit  = [[QEntryElement alloc] initWithTitle:@"利率保障倍数EBIT" Value:nil Placeholder:@"万元"];
    ebit.prefix = @"(万元)";
    ebit.keyboardType = UIKeyboardTypeNumberPad;
    [section2 addElement:ebit];
    
    [root addSection:section2];
    
    return root;
}

@end

@implementation TrutWaysDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"增信方式";
	QSection *section = [[QSection alloc] init];
    
    QLabelElement *assets_pledge = [[QLabelElement alloc] initWithTitle:@"资产抵押" Value:nil];
    assets_pledge.controllerAction = @"showAssertsTypes:";
    [section addElement:assets_pledge];
    
    QLabelElement *guarantee = [[QLabelElement alloc] initWithTitle:@"担保保证" Value:nil];
    guarantee.controllerAction = @"showGuaranteeTypes:";
    [section addElement:guarantee];

    QLabelElement *internal_enhancements = [[QLabelElement alloc] initWithTitle:@"内部增级" Value:nil];
    internal_enhancements.controllerAction = @"showEnhancementsWays:";
    [section addElement:internal_enhancements];
    
    QLabelElement *bank_support = [[QLabelElement alloc] initWithTitle:@"银行流动性支持" Value:nil];
    bank_support.controllerAction = @"showBankSupportWays:";
    [section addElement:bank_support];
    
    QLabelElement *other = [[QLabelElement alloc] initWithTitle:@"其他增信方式" Value:nil];
    other.controllerAction = @"showOtherTrustWays:";
    [section addElement:other];

    [root addSection:section];
    
    return root;
}



@end

@implementation AssertsTypesDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"新增资产抵制押";
	QSection *section = [[QSection alloc] init];
    
    QLabelElement *land = [[QLabelElement alloc] initWithTitle:@"土地" Value:nil];
    land.controllerAction = @"showLandTypes:";
    [section addElement:land];
    
    QLabelElement *estate = [[QLabelElement alloc] initWithTitle:@"房产" Value:nil];
    estate.controllerAction = @"showEstateTypes:";
    [section addElement:estate];
    
    QLabelElement *equity = [[QLabelElement alloc] initWithTitle:@"股权" Value:nil];
    equity.controllerAction = @"showEquityTypes:";
    [section addElement:equity];
    
    QLabelElement *receivables = [[QLabelElement alloc] initWithTitle:@"应收账款" Value:nil];
    receivables.controllerAction = @"showReceivablesTypes:";
    [section addElement:receivables];
    
    [root addSection:section];
    
    return root;
}

@end

@implementation GuaranteeDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"保证担保";
    
    QSection *section = [[QSection alloc] init];
    section.title = @"担保方";
    QEntryElement *e1  = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"担保方"];
    [section addElement:e1];
    
    QButtonElement *btn = [[QButtonElement alloc] initWithTitle:@"添加"];
    btn.controllerAction = @"handleEquityAddButtonTapped:";
    [section addElement:btn];
    
    QSelectSection *section2 =
    [[QSelectSection alloc] initWithItems:[NSArray arrayWithObjects:@"全额无条件不可撤销连带责任", @"有限责任", @"部分担保",  nil]
                          selectedIndexes:nil title:nil];
    section2.multipleAllowed = YES;
    section2.title = @"担保方式";

    QSection *section3 = [[QSection alloc]init];
    [section3 addElement:[[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"其他"]];
    
    [root addSection:section];
    [root addSection:section2];
    [root addSection:section3];
    
    return root;
}


@end

@implementation LandTypesDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"土地";

    QSelectSection *section =
    [[QSelectSection alloc] initWithItems:[NSArray arrayWithObjects:@"商业", @"住宅",  nil]
                          selectedIndexes:nil title:nil];
    section.multipleAllowed = YES;
    section.title = @"性质";
    
    QSection *section2 = [[QSection alloc] init];
    QEntryElement *total_assets  = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"其他性质"];
    [section2 addElement:total_assets];
    
    QSection *section3 = [[QSection alloc]init];
    QEntryElement *e1  = [[QEntryElement alloc] initWithTitle:@"土地面积" Value:nil Placeholder:@"万平方米"];
    e1.prefix = @"(万平方米)";
    e1.keyboardType = UIKeyboardTypeNumberPad;
    [section3 addElement:e1];

    QEntryElement *e2  = [[QEntryElement alloc] initWithTitle:@"转让价值" Value:nil Placeholder:@"亿"];
    e2.prefix = @"(%)";
    e2.keyboardType = UIKeyboardTypeNumberPad;
    [section3 addElement:e2];

    QEntryElement *e3  = [[QEntryElement alloc] initWithTitle:@"覆盖倍数" Value:nil Placeholder:@"倍"];
    e3.prefix = @"倍";
    e3.keyboardType = UIKeyboardTypeNumberPad;
    [section3 addElement:e3];
    
    NSArray *types = @[@"有", @"无", @""];
    [section3 addElement: [[QPickerElement alloc] initWithTitle:@"土地出让证明" items:@[types] value:nil]];
   
    [root addSection:section];
    [root addSection:section2];
    [root addSection:section3];
    
    return root;
}

@end


@implementation EstateTypesDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"房产";
    
    QSelectSection *section =
    [[QSelectSection alloc] initWithItems:[NSArray arrayWithObjects:@"商业", @"住宅",  nil]
                          selectedIndexes:nil title:nil];
    section.multipleAllowed = YES;
    section.title = @"性质";
    
    QSection *section2 = [[QSection alloc] init];
    QEntryElement *total_assets  = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"其他性质"];
    [section2 addElement:total_assets];
    
    QSection *section3 = [[QSection alloc]init];
    QEntryElement *e1  = [[QEntryElement alloc] initWithTitle:@"评估价值" Value:nil Placeholder:@"万平方米"];
    e1.prefix = @"(万平方米)";
    e1.keyboardType = UIKeyboardTypeNumberPad;
    [section3 addElement:e1];
    
    QEntryElement *e2  = [[QEntryElement alloc] initWithTitle:@"覆盖倍数" Value:nil Placeholder:@"倍"];
    e2.prefix = @"(倍)";
    e2.keyboardType = UIKeyboardTypeNumberPad;
    [section3 addElement:e2];
    
    NSArray *types = @[@"有", @"无", @""];
    [section3 addElement: [[QPickerElement alloc] initWithTitle:@"房产证" items:@[types] value:nil]];
    
    [root addSection:section];
    [root addSection:section2];
    [root addSection:section3];
    
    return root;
}

@end

@implementation EquityDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"股权";
    
    QSection *section  = [[QSection alloc] init];
    section.title = @"股权所有人";
    QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"股权所有人"];
    [section addElement:e1];
    
    QButtonElement *btn = [[QButtonElement alloc] initWithTitle:@"添加"];
    btn.controllerAction = @"handleEquityAddButtonTapped:";
    [section addElement:btn];

    
    QSection *section2  = [[QSection alloc] init];
    QEntryElement *e2  = [[QEntryElement alloc] initWithTitle:@"质押金额" Value:nil Placeholder:@"亿"];
    e2.prefix = @"(亿)";
    e2.keyboardType = UIKeyboardTypeNumberPad;
    [section2 addElement:e2];

    QEntryElement *e3  = [[QEntryElement alloc] initWithTitle:@"覆盖倍数" Value:nil Placeholder:@"倍"];
    e3.prefix = @"(倍)";
    e3.keyboardType = UIKeyboardTypeNumberPad;
    [section2 addElement:e3];

    [root addSection:section];
    [root addSection:section2];
    
    return root;
}

@end


@implementation ReceivablesDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"应收账款";
    
    QSection *section  = [[QSection alloc] init];
    section.title = @"应收账款对象";
    QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"应收账款对象"];
    [section addElement:e1];
    
    QButtonElement *btn = [[QButtonElement alloc] initWithTitle:@"添加"];
    btn.controllerAction = @"handleEquityAddButtonTapped:";
    [section addElement:btn];
    
    
    QSection *section2  = [[QSection alloc] init];
    QEntryElement *e2  = [[QEntryElement alloc] initWithTitle:@"应收账款余额" Value:nil Placeholder:@"亿"];
    e2.prefix = @"(亿)";
    e2.keyboardType = UIKeyboardTypeNumberPad;
    [section2 addElement:e2];
    
    QEntryElement *e3  = [[QEntryElement alloc] initWithTitle:@"覆盖倍数" Value:nil Placeholder:@"倍"];
    e3.prefix = @"(倍)";
    e3.keyboardType = UIKeyboardTypeNumberPad;
    [section2 addElement:e3];
    
    [root addSection:section];
    [root addSection:section2];
    
    return root;
}


@end

@implementation EnhancementsDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"内部增级";
    
    QSelectSection *section =
    [[QSelectSection alloc] initWithItems:[NSArray arrayWithObjects:@"偿债基金", @"结构化分级",  nil]
                          selectedIndexes:nil title:nil];
    section.multipleAllowed = YES;

    QSection *section2  = [[QSection alloc] init];
    section.title = @"其他";
    QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:@"其他"];
    [section2 addElement:e1];

    [root addSection:section];
    [root addSection:section2];
    
    return root;
}


@end


@implementation BankSupportDataBuilder

+ (QRootElement *)create {
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"银行流动性支持";
    
    QSection *section = [[QSection alloc] init];
    section.title = @"银行名称";
    QEntryElement *e1 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:nil];
    [section addElement:e1];
   
    QSection *section2  = [[QSection alloc] init];
    section2.title = @"其他";
    QEntryElement *e2 = [[QEntryElement alloc]initWithTitle:nil Value:nil Placeholder:nil];
    [section2 addElement:e2];
    
    [root addSection:section];
    [root addSection:section2];
    
    return root;
}

@end