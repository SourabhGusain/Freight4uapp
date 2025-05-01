import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:signature/signature.dart';
import 'package:Freight4u/widgets/ui.dart';
import 'package:Freight4u/helpers/widgets.dart';
import 'package:Freight4u/widgets/form.dart';
import 'package:Freight4u/helpers/values.dart';
import 'package:Freight4u/pages/format/format.controller.dart';

class PolicyPage extends StatefulWidget {
  final String policy;

  const PolicyPage({super.key, required this.policy});

  @override
  State<PolicyPage> createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  late SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penColor: Colors.black,
      penStrokeWidth: 5.0,
      exportBackgroundColor: Colors.transparent,
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  String getPolicyMarkdown(String policy) {
    switch (policy) {
      case "Speeding Policy":
        return """
# Hunter and Northern Logistics (HNL) Speed Compliance Policy

Hunter and Northern Logistics will have systems in place to ensure all drivers, sub-contractors, and employees comply with the law regarding safe speed. This includes safe speed within Distribution Centres and other points of delivery. Failure to adhere to this policy will result in disciplinary action, including instant dismissal.

## HNL Will:

- **Fit speed limiters** to all heavy vehicles to deter speeding.
- **Reserve the right** to discipline any employee or person who breaches this policy or appropriate legal requirements.
- **Fit GPS systems** to vehicles that provide speed warnings to management.
- **Ensure driver schedules** are prepared with speed compliance included.
- **Require copies of all drivers and sub-contractors' RMS driving records** prior to employment or engagement with HNL.
- **Undertake effective communication** with employees on matters relating to speed management via toolbox meetings.
- **Investigate and act upon all breaches** of this policy.
- **Exceeding speed limits for more than 4 seconds** will alert management and a warning will be issued.
- **Exceeding 110 km/hr** will result in instant dismissal.

""";

      case "No Smoking Policy":
        return """
# Hunter & Northern Logistics Pty Ltd (NSW) Smoking Policy

The objective of this policy is to assist in providing a safe and healthy work environment for everyone. Smoking is not permitted in all internal areas of our work location, any area deemed hazardous, or designated **NO SMOKING** areas. 

This policy has been implemented in the interest of protecting the health and wellbeing of everyone. It is **not** meant to infringe upon any individual’s right to choose. 

## Policy Review
This policy will be reviewed annually or earlier if required.

""";

      case "Drug & Alcohol Policy Statement":
        return """
# Hunter & Northern Logistics Pty Ltd (NSW) Drug and Alcohol Policy

Hunter & Northern Logistics is committed to providing a work environment that ensures the health and safety of every person involved with the company’s operations. This policy acknowledges that individuals impaired by the effects of drugs or alcohol may present a risk to the health and safety of their workmates and themselves. The purpose of this policy is to ensure a work environment that is free from such risks.

## Prohibited Activities

- The consumption of drugs or alcoholic beverages in the workplace by any employee is **prohibited**.
- No employee is to commence work, remain at work, or return to work while under the influence of drugs or alcohol.

## Blood Alcohol Content (BAC)

- Hunter & Northern Logistics' blood alcohol content (BAC) policy is **0.05%**.
- In cases where relevant legislation requires a **0.00% BAC**, such as under **Road Transport Laws**, the stricter policy will apply.

## Customer Site Policy

- Where an employee or contractor is engaged to perform work for Hunter & Northern Logistics at a customer’s site, **all policies of that customer will apply**.
- Where there is a discrepancy between the customer’s policy and HNL's, the **higher-order policy** will apply.

## Testing and Fitness for Work

Testing for drug and alcohol consumption may be conducted:
- As part of the **pre-employment medical process**.
- **Randomly**.
- **Post-incident**.
- **For cause**, where it is reasonably suspected that a person may be under the influence of drugs or alcohol.

## Applicability

This policy applies to:
- All persons employed by **HNL, NFG**, including contractors and their employees, and visitors to the site.
- All company business, conducted both **on** and **off** site.

## Consequences of Breach

The consequences of breaching this policy may include **disciplinary action**, up to and including **instant dismissal**.

""";

      case "Social Media Policy":
        return """
# Hunter & Northern Logistics Pty Ltd (NSW) Social Media Policy

Hunter & Northern Logistics recognizes the importance of all types of social media in shaping public opinion about our company, employees, and customers. We also recognize the importance of our employees joining in and helping shape industry conversations and direction through blogging and interacting across various media platforms.

Hunter & Northern Logistics is committed to supporting your right to interact knowledgeably and socially on the Internet and through other forms of media such as newspapers, UHF radios, magazines, etc. Consequently, the guidelines in this social media policy will help you make appropriate decisions about your work-related comments, blogging, and interactions on social media platforms.

## Scope of the Policy

This policy applies to:
- Work-related comments on blogs, websites, Facebook, YouTube, or any other interactive sites.
- Postings on video or picture-sharing sites.
- Comments made over the radio, mobile phones, magazines, newspapers, emails, and internal internet systems.
  
These guidelines will help you engage in respectful and knowledgeable interactions while protecting the privacy, confidentiality, and interests of Hunter & Northern Logistics and its customers, employees, and management. Note that this policy applies only to **work-related information** and is not intended to restrict your personal online interactions or commentary.

## Guidelines for Interaction About Hunter & Northern Logistics on the Internet

- If you are writing a blog that mentions **Hunter & Northern Logistics**, its customers, employees, or management, identify that you are an employee and that the views expressed are your own, not the company’s.
- Unless authorized by a director, **do not speak on behalf of the company** through social media or other forms of public communication.

## Confidential Information Component of the Social Media Policy

- **Do not share confidential company information**, including but not limited to:
  - Current workloads, freight being carried, finances, fleet information, employee details, pay rates, enterprise agreement negotiations, customer rates, or any non-publicly released company information.
- If you're unsure about whether information is confidential or publicly released, **consult with your manager or director** before sharing any information that could potentially harm Hunter & Northern Logistics or its customers, employees, or management.
- **Do not use the company logo** without explicit written permission from a company director.

## Respect and Privacy Rights Components of the Social Media Policy

- Speak respectfully about the company, its customers, employees, and management. Avoid name-calling or any actions that could harm Hunter & Northern Logistics' reputation.
- **Do not engage in defamatory, harassing, or negative behavior** that may reflect poorly on the company. Misrepresentation or using copyrighted materials without permission may result in disciplinary action, including termination of employment.
- **Respect the privacy of employees and management** by obtaining their permission before discussing internal company matters that might violate their privacy or confidentiality. Failure to comply can result in immediate dismissal.

## Your Legal Liability Component of the Social Media Policy

- **You are legally responsible** for any content you post online or share through print media (e.g., newspapers, magazines) or communication devices (e.g., mobile phone messages, UHF radios).
- You may face **disciplinary action** from the company for commentary, content, or images that are defamatory, harassing, or that create a hostile work environment. Additionally, you could face legal action from the company or individuals if your content is deemed harmful.
- **Unless given permission by a director**, you are **not authorized to speak on behalf of the company** through any form of social media, print media, emails, mobile phone messaging, phone calls, or any communication device related to company business.

""";

      case "Toll Road Policy":
        return """
# Hunter & Northern Logistics Pty Ltd (NSW/QLD) Tollway Usage Policy

The current **Group policy** on the use of NSW or Queensland Tollways is that **we do not use tolls** unless approval is granted by your manager. This must be recorded on your worksheet.

You are **not permitted** to use tollways or roads where e-tags are required, except in the following cases:

## Exceptions

- **M1 (NorthConnex) Tunnel in NSW**:  
  At Wahroonga and Pennant Hills, it has been legislated by the NSW Government that it must be used by all heavy vehicles. Use the **Cumberland Hwy exit**, **James Ruse Drive**, and **Pennant Hills Road** to Wahroonga onto the M1 NorthConnex for North Coast deliveries.

- **Canberra B-Double trips**:  
  You will need to use the **M7** for these trips. All single ACT runs from **Cowpasture Road** on ramp and the **Harbour Bridge/Tunnel** to traverse the harbour crossing between deliveries.

- **M4/WestConnex**:  
  **Not permitted**.

- **Cumberland Hwy**:  
  Use **Cumberland Hwy exit**, **James Ruse Drive**, and **Victoria Road** for all **North Sydney and North Shore deliveries**.

- **Long country trips**:  
  The only other exception will be if you are returning from a long country trip and need to use the tollway to arrive at the warehouse within your legal driving hours. Drivers on these runs will already be aware and have been advised of these exemptions and not to be abused.

- **Manager/Supervisor Instructions**:  
  From time to time, your **manager or supervisor** may ask you to return via a toll road to improve your return time for a specific purpose on that day. However, this is **not approval** for you to use that, or any other toll road, in the future. **Permission** must be granted by the **Operations Manager** and documented on your **runsheet**.

## Consequences for Non-Compliance

- Any driver disobeying this instruction will have **any charges levied against HNL** charged back to them.
- **Tolls cost the company over Doller 250,000 per annum**, and **no one will request** you to use toll roads unless explicitly required.

---

# **NorthConnex Notation**

- All vehicles over **2.8m high** or **12 metres in length** MUST use the tunnel in both directions. All of our trucks are banned from **Pennant Hills Rd**, as they are all over **2.8m high** and most are over **12m in length**.

- There are **cameras and gantries** at either end of the road that will automatically fine the company **Doller 191.00 per event** for every truck on **Pennant Hills Rd**.

- **You MUST use the tunnel**.

## Exceptions for Pennant Hills Road:

- The only exception is if you are delivering to a location **on, or just off Pennant Hills Rd**.
- Others are if you are carrying **placarded Dangerous Goods** or a load that has an **oversize permit**.

- **If you travel along Pennant Hills Rd** and don’t use the tunnel, you will be fined **Doller 191.00 per event**. 
  - The fine will be **nominated** by the company and the fine will come to you.
  - **No excuses** will be accepted for not following this law.

---

## Additional Information

- Hunter & Northern Logistics has been **active and vocal** within the industry and **NSW Parliament** to try and change this legislation. However, as it is a deal between the **NSW Government** and the tunnel owner, it is very difficult to change.

- This tunnel charge is **CPI adjusted** **4 times per year** for the next **40 years**. This will cost our customers **over Doller 1,000,000 in extra charges per annum**.

- The cost to people who live **north beyond the tunnel** is in the **billions of dollars**. The NSW Government has **hidden** this fact.

---

# Acknowledgment

This note is being given to you personally to ensure there is no confusion or misunderstanding. A copy of some of the information provided by the government is also being given to you to help you understand this very serious issue.

**Please sign the declaration below** to confirm that you have received this letter, read the information, and fully understand what is required of you.

---

""";

      case "DC - Fit For Work Policy":
        return """
# Fit For Work Policy

- Workers must be physically and mentally ready before shifts.
""";

      case "Mobile Phone Policy Statement":
        return """
# Mobile Phone Policy

- Hands-free only while driving.
- No texting/calling while operating vehicles.
""";

      case "Harassment / Discrimination Policy":
        return """
# Harassment / Discrimination Policy

- Zero tolerance.
- All cases investigated immediately.
""";

      case "Food, Safety & Quality Policy":
        return """
# Food, Safety & Quality Policy

- Adhere to safe food handling practices.
- Maintain hygiene and quality standards.
""";

      case "Fatigue Management Policy":
        return """
# Fatigue Management Policy

- Take breaks as scheduled.
- Report signs of fatigue early.
""";

      case "Contractor Management Policy":
        return """
# Contractor Management Policy

- Contractors must follow company safety and behavior rules.
""";

      case "Chain of Responsibility Policy":
        return """
# Chain of Responsibility Policy

- Every role in transport chain shares accountability for safety.
""";

      default:
        return "Policy content for '${widget.policy}' not available.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final markdown = getPolicyMarkdown(widget.policy);

    return ViewModelBuilder<FormatController>.reactive(
      viewModelBuilder: () => FormatController(),
      onViewModelReady: (ctrl) => ctrl.init(),
      builder: (context, ctrl, child) {
        return SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(65),
              child: secondaryNavBar(context, "${widget.policy}"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarkdownWidget(
                    data: markdown,
                    shrinkWrap: true,
                    selectable: true,
                    config: MarkdownConfig(configs: [
                      const PConfig(textStyle: TextStyle(fontSize: 15)),
                      const H1Config(
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const H2Config(
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                  const SizedBox(height: 20),
                  textH3("Signature:", font_size: 17),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                    ),
                    child: Signature(
                      controller: _signatureController,
                      height: 200,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 25,
                      width: 90,
                      child: darkButton(
                        buttonText("Clear", color: whiteColor, font_size: 10),
                        primary: primaryColor,
                        onPressed: () {
                          _signatureController.clear();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: darkButton(
                      buttonText("Save", color: whiteColor),
                      primary: primaryColor,
                      onPressed: () {
                        // Save logic placeholder
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signature saved.')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
