/*
Copyright (C) 2023 Stephen Tigner

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

class ApplicationStrings {
  static const applicationTitle = "Better Buy";

  //ComparisonItem widget
  static const itemNameLabel = "Item name (optional)";

  static const packagePriceLabel = "Price";
  static const packageUnitsAmountLabel = "Amount";
  static const multiPackLabel = "Multi-pack";
  static const packageItemCountLabel = "# of Items";
  static const scanLabelTooltip = "Scan package label for unit measurements";
  static const cropImageTitle = "Crop Image";
  static const cropImageDoneButton = "Done";
  static const cropImageCancelButton = "Cancel";
  static const noMeasurementsFoundError =
      "No unit measurements found in the image";
  static const scanningErrorMessage = "Error scanning label";
  static const cameraDeniedMessage =
      "Camera permission is required to scan labels";

  // Text Recognition UI
  static const selectMeasurementTitle = "Select Measurement";
  static const acceptMeasurementButton = "Use This Measurement";
  static const retryButton = "Try Again";
  static const newPhotoButton = "Take New Photo";

  static const standardizedUnitsLabel = "Compare all items using";

  static const deletedItemLabel = "Item deleted";
  static const restoreItemLabel = "Undo";

  static const currencySymbol = "\$";
  static const unitPriceLabel = "Unit Price";

  //Menu links
  static const privacyPolicyLink =
      "https://github.com/stephentigner/public_docs/blob/main/simple_mobile_app_privacy_policy.md";
  static const privacyPolicyLinkText = "Privacy Policy";

  static const licenseLink =
      "https://github.com/stephentigner/shopping_units/blob/main/LICENSE.md";
  static const licenseLinkText = "License";
}
