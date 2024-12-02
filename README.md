English | [中文](README_zh.md)

# Cangyan

Welcome to Cangyan, a convenient and flexible tool for collaborative translation work on images. It helps save, transfer, and read translated text, reducing communication costs between team members, minimizing workload, and improving efficiency. This project aims to establish a relatively complete workflow and provide a lightweight open-source solution for image translation tasks.

## Background

Image translation work (such as comic localization) can generally be summarized into the following two steps:

1. Translating the text in the image into the corresponding content and recording the location of the translated text in the original image.
2. After completing the translation, the original image needs to be processed by overlaying the translated text on top of the original text.

The staff leading these two steps are typically referred to as "translator" and "typographer," respectively. In larger translation organizations, there might also be specialized roles like "proofreader," "image retoucher," and "supervisor." These specialized positions generally fall under the two main categories, so the focus of discussion here is on these two roles.
When the translation and typography work is done by the same person or by multiple people capable of performing both tasks, there is no communication gap. However, in most cases, translators are fewer, while those who can handle typography are in greater numbers. Due to limited time and energy, the usual arrangement is for translators to focus on translation, and those not suited for translation will handle typography. This difference in capabilities often leads to communication barriers.
An obvious solution is for the translator to save the translated content in a separate text file and then package the original image and the translation file to send to the typographer. However, this approach has its own issue: the location information of the translated text relative to the original text cannot be preserved or conveyed. The typographer cannot determine where to place the text in the original image based solely on the original image and translation.
Another approach is for the translator to modify the original image by writing or typing on it at the corresponding positions, and then send the modified file to the typographer for further work. However, this solution is also inconvenient. The translator's main work should focus on text processing rather than image editing. Modifying the original image requires specialized image editing software, not text processing software, leading to unnecessary overhead. Moreover, heavily covering the original image can cause visual fatigue and make it harder to read. Whether making the translation semi-transparent or the original image semi-transparent, both options affect visibility.
To address these issues, this project was created.

## Features

Cangyan offers a solution that packages both translated text and location information within image files, making it easier to transfer between different positions in the project. Additionally, to make translation and reading more convenient, the software provides a simple and intuitive interface. By marking the image, it ensures the inclusion of translation location information while maintaining readability.

## License

This project follows the MIT license for open-sourcing the source code. We welcome suggestions or contributions to the development of this project.