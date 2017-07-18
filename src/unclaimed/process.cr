require "csv"

class FileProcessor

  def initialize
  end

  def process
    process_file(2010)
    (1986..2015).each do |year|
      #res = process_file(year)
      #create_csv(year, res)
    end
  end

  def process_file(year)
    lines = File.read_lines("./files/#{year}.txt", "UTF-8", :skip).compact_map{|line| process(line) }
    selected_lines = lines.select{|hsh| hsh[:amount] > 1000 }

    p "#{year} #{selected_lines.size}"

  end

  def create_csv(year, lines)
    CSV.build do |csv|
      csv.row "year",
              "line",
              "first_name",
              "last_name",
              "address_1",
              "city",
              "state",
              "zip",
              "amount",
              "prop_type"
      lines.each_with_index do |line, idx|
        csv.row year,
                idx,
                line[:first_name],
                line[:last_name],
                line[:address_1],
                line[:city],
                line[:state],
                line[:zip],
                line[:amount],
                line[:property_type]
      end
    end

    File.write("#{year}-unclaimed.csv", res)
  end

  def process(line)
    return if line.size < 450

    first_name = line[40..69].strip
    last_name  = line[0..6].strip

    address_1  = line[70..99].strip
    address_2  = line[100..129].strip
    address_3  = line[130..159].strip
    city       = line[160..189].strip
    state      = line[190..191].strip
    zip        = line[192..200].strip

    tax_id     = line[201..209].strip
    p "#{first_name} #{last_name} #{address_1}"
    amount     = line[248..257].strip.to_i64

    holder_contact     = line[280..319].strip
    holder_address_1   = line[320..349].strip
    holder_city        = line[410..439].strip
    holder_state       = line[440..441].strip
    holder_zip         = line[442..450].strip

    property_type = line[217..220].strip

    {
      first_name: first_name,
      last_name: last_name,

      address_1: address_1,
      address_2: address_2,
      address_3: address_3,
      city: city,
      state: state,
      zip: zip,

      tax_id: tax_id,
      amount: amount,

      holder_contact: holder_contact,
      holder_address_1: holder_address_1,
      holder_city: holder_city,
      holder_state: holder_state,
      holder_zip: holder_zip,

      property_type: begin PROP_TYPES[property_type] rescue "Misc" end,
    }
  end

  PROP_TYPES = {
    ""     => "None",
    "0500" => "Misc",
    "ACZZ" => "Misc",
    "CKZZ" => "Misc",
    "C010" => "Misc",
    "C020" => "Misc",
    "C130" => "Misc",
    "INZZ" => "Misc",
    "I020" => "Misc",
    "K010" => "Misc",
    "K100" => "Misc",
    "MIZZ" => "Misc",
    "MSZZ" => "Misc",
    "N020" => "Misc",
    "TRZZ" => "Misc",
    "T040" => "Misc",

    "IN01" => "Misc Insurance",
    "AC01" => "Checking Account",
    "AC02" => "Savings Account",
    "AC03" => "Matured CD",
    "AC04" => "Christmas Club Acct",
    "AC05" => "Money on Deposit",
    "AC06" => "Security Deposit",
    "AC07" => "Unidentified Deposit",
    "AC08" => "Suspense Account",
    "CK01" => "Cashier's Check",
    "CK02" => "Certified Check ",
    "CK03" => "Registered Check",
    "CK04" => "Treasurer's Check",
    "CK05" => "Draft",
    "CK06" => "Warrant",
    "CK07" => "Money Order",
    "CK08" => "Traveler's Check",
    "CK09" => "Foreign Exchng Check",
    "CK10" => "Expense Check",
    "CK11" => "Pension Check",
    "CK12" => "Credit Check or Memo",
    "CK13" => "Vendor Check",
    "CK14" => "Check Written Off",
    "CK15" => "Official Check",
    "CK16" => "CD Interest Check",
    "CK17" => "Money Order",
    "CT01" => "Escrow Funds W/Court",
    "CT02" => "Condemnation Award",
    "CT03" => "Missing Heir Funds",
    "CT04" => "Suspense Account",
    "CT05" => "Court Deposit - Misc",
    "IN02" => "Grp Clm Pmt/Benefit",
    "IN03" => "Death Benefit",
    "IN04" => "Matured Policy Endow",
    "IN05" => "Premium Refund",
    "IN06" => "Unidentified Remit",
    "IN07" => "Amt Due Per Policy",
    "IN08" => "Agent Credit Balance",
    "IP99" => "Interest Penalty",
    "MI01" => "Net Revenue Interest",
    "MI02" => "Mineral Royalty",
    "MI03" => "Overriding Royalty",
    "MI04" => "Production Payment",
    "MI05" => "Working Interest",
    "MI06" => "Bonus",
    "MI07" => "Delay Rental",
    "MI08" => "Shut-In Royalty",
    "MI09" => "Minimum Royalty",
    "MI10" => "Ongoing Production",
    "MS01" => "Wages",
    "MS02" => "Commission",
    "MS03" => "Workers Comp Benefit",
    "MS04" => "Pmt for Goods or Svc",
    "MS05" => "Customer Overpayment",
    "MS06" => "Unidentified Remit",
    "MS07" => "Unrefunded Overchrg",
    "MS08" => "Accounts Payable",
    "MS09" => "Credit Bal/Acct Recv",
    "MS10" => "Discount Due",
    "MS11" => "Refund Or Rebate Due",
    "MS12" => "Unredeemed Gift Cert",
    "MS13" => "Loan Collateral",
    "MS14" => "Pension/Profit Shr",
    "MS15" => "Dissolution Proceeds",
    "MS16" => "Misc Outstanding Ck",
    "MS17" => "Misc Intangible Prop",
    "MS18" => "Suspense Liability",
    "RECP" => "Reciprocal Property",
    "RR01" => "Salvaged O&G Equip",
    "RR02" => "Condensate Proceeds",
    "SCZZ" => "Other Securities",
    "SC01" => "Dividend",
    "SC02" => "Registered Bond Int",
    "SC03" => "Principal Payment",
    "SC04" => "Equity Payment",
    "SC05" => "Profits",
    "SC06" => "Funds Pd for Shares",
    "SC07" => "Bearer Bond Int/Prin",
    "SC08" => "Undelivered Stock",
    "SC09" => "Cash In Lieu Frac Sh",
    "SC10" => "Unexchanged Stock",
    "SC11" => "Other Cert of Ownshp",
    "SC12" => "Underlying Shares",
    "SC13" => "Liq/Redemp Proceeds",
    "SC14" => "Debenture",
    "SC15" => "US Govt Security",
    "SC16" => "Book-Entry Mut Funds",
    "SC17" => "Warrants or Rights",
    "SC18" => "Registered Bond Prin",
    "SC19" => "Dividend Reinvst Pln",
    "SC20" => "Credit Balance",
    "SC22" => "Non-Trnsferable Shs",
    "SC23" => "Non-Trnsferable Shs",
    "SC85" => "Demutualization Cash Proceeds",
    "SC86" => "Demutualization Shares",
    "SD01" => "SD Box Contents",
    "SD02" => "Safekeeping Property",
    "SD03" => "Misc Tangible Prop",
    "SD04" => "Loan Collateral",
    "TR01" => "Paying Agent Account",
    "TR02" => "Dividends",
    "TR03" => "Fiduciary Funds",
    "TR04" => "Escrow Account",
    "TR05" => "Trust Voucher",
    "TR06" => "Pre-Need Funeral Pln",
    "UT01" => "Utility Deposit",
    "UT02" => "Membership Fee",
    "UT03" => "Refund or Rebate",
    "UT04" => "Capital Credit Dist",
    "ZZZZ" => "Unknown Property Type"
  }
end
