// ==UserScript==
// @name         Amazon.ca Advanced Image Enlarger with Delays and Smart Positioning
// @namespace    http://tampermonkey.net/
// @version      0.6
// @description  Feature-rich image enlarger for Amazon.ca with smart positioning
// @author       You
// @match        *://www.amazon.ca/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    let timeoutId, hideTimeout;
    let isDragging = false;

    // Create a div to hold the enlarged image
    const popupDiv = document.createElement('div');
    popupDiv.id = 'image-popup';
    popupDiv.style.position = 'absolute';
    popupDiv.style.zIndex = '10000';
    popupDiv.style.display = 'none';
    popupDiv.style.border = '2px solid black';
    popupDiv.style.resize = 'both';
    popupDiv.style.overflow = 'auto';
    document.body.appendChild(popupDiv);

    // // Function to allow dragging
    // const dragPopup = (e) => {
    //     if (!isDragging) return;
    //     popupDiv.style.left = `${e.clientX - 20}px`;
    //     popupDiv.style.top = `${e.clientY - 20}px`;
    // };


let startX, startY, startLeft, startTop;

// Function to start dragging
const startDrag = (e) => {
    isDragging = true;
    startX = e.clientX; // Set the initial mouse X position
    startY = e.clientY; // Set the initial mouse Y position
    startLeft = parseInt(popupDiv.style.left, 10) || 0;
    startTop = parseInt(popupDiv.style.top, 10) || 0;
    document.addEventListener('mousemove', dragPopup);
};

// Function to handle dragging
const dragPopup = (e) => {
    if (!isDragging) return;
    let dx = e.clientX - startX; // Calculate the difference from the starting X position
    let dy = e.clientY - startY; // Calculate the difference from the starting Y position
    popupDiv.style.left = `${startLeft + dx}px`; // Update the popup's left position
    popupDiv.style.top = `${startTop + dy}px`; // Update the popup's top position
};

// Function to stop dragging
const stopDrag = () => {
    isDragging = false;
    document.removeEventListener('mousemove', dragPopup);
    localStorage.setItem('popupPosX', popupDiv.style.left);
    localStorage.setItem('popupPosY', popupDiv.style.top);
};

const showPopup = (e) => {
    console.log('showPopup triggered');
    clearTimeout(timeoutId); // Clear any existing timeout to prevent multiple triggers

    timeoutId = setTimeout(() => {
        console.log('Preparing to show popup');
        const imgSrc = e.target.src;
        if (!imgSrc) {
            console.log('No image source found');
            return; // Exit if the src is not found
        }

        const aspectRatio = e.target.naturalWidth / e.target.naturalHeight;
        let popupWidth = Math.min(Math.floor(window.innerWidth * 0.4), 300);
        let popupHeight = Math.floor(popupWidth / aspectRatio);

        console.log(`Image aspect ratio: ${aspectRatio}`);
        console.log(`Popup dimensions: ${popupWidth}x${popupHeight}`);

        // Use saved position if available, otherwise use the event's position
        let posX = parseInt(localStorage.getItem('popupPosX'), 10) || e.clientX;
        let posY = parseInt(localStorage.getItem('popupPosY'), 10) || e.clientY;

        if (!localStorage.getItem('popupPosX')) {
            posX -= popupWidth / 2; // Center the popup on the cursor
            posY -= popupHeight / 2;
        }

        console.log(`Popup position: ${posX}px, ${posY}px`);

        let img = new Image(); // Create a new Image object
        img.onload = () => { // Ensure the image is loaded before displaying
            console.log('Image loaded, displaying popup');
            popupDiv.innerHTML = ''; // Clear existing content
            popupDiv.appendChild(img); // Add the image to the popup
            popupDiv.style.left = `${posX}px`;
            popupDiv.style.top = `${posY}px`;
            popupDiv.style.display = 'block'; // Make sure the popup is visible
        };
        img.onerror = () => {
            console.log('Failed to load image');
        };
        img.src = imgSrc; // Set the image source, triggering the load
        img.style.width = `${popupWidth}px`;
        img.style.height = `${popupHeight}px`;

        console.log('Image source set, waiting for load');
    }, 1000); // Adjust the delay as needed
}

    console.log('Timeout set for popup display');

    // Function to hide the enlarged image
    const hidePopup = (e) => {
        hideTimeout = setTimeout(() => {
            if (!isDragging && !e.shiftKey) {
                popupDiv.style.display = 'none';
            }
        }, 1000);
    };

    // Function to attach hover events to product images
    const attachHoverEvents = () => {
        document.querySelectorAll('.s-image-square-aspect > .s-image')
            .forEach((img) => {
            img.removeEventListener('mouseover', showPopup);
            img.removeEventListener('mouseout', hidePopup);
            img.addEventListener('mouseover', showPopup);
            img.addEventListener('mouseout', hidePopup);
        });
    };

    // Attach hover events initially
    attachHoverEvents();


    // Function to zoom in/out the popup image
    const zoomPopup = (e) => {
        if (!e.shiftKey) return;

        const zoomFactor = 0.05; // Adjust for sensitivity
        let popupImage = popupDiv.querySelector('img');
        if (popupImage) {
            let currentWidth = popupImage.clientWidth;
            let currentHeight = popupImage.clientHeight;

            if (e.deltaY < 0) { // Zoom in
                popupImage.style.width = `${currentWidth * (1 + zoomFactor)}px`;
                popupImage.style.height = `${currentHeight * (1 + zoomFactor)}px`;
            } else if (e.deltaY > 0) { // Zoom out
                popupImage.style.width = `${currentWidth * (1 - zoomFactor)}px`;
                popupImage.style.height = `${currentHeight * (1 - zoomFactor)}px`;
            }
        }
    };
    // Make the popup draggable
    // popupDiv.addEventListener('mousedown', () => isDragging = true);
    // popupDiv.addEventListener('mouseup', () => isDragging = false);
    popupDiv.addEventListener('mousemove', dragPopup);
    popupDiv.addEventListener('mouseout', () => isDragging = false);

    popupDiv.addEventListener('mousedown', startDrag);
    document.addEventListener('mouseup', stopDrag);

    // Function to hide the popup when Shift + Escape is pressed
    const hidePopupOnKey = (e) => {
        if (e.shiftKey && e.key === 'Escape') {
            popupDiv.style.display = 'none';
        }
    };

    // Add hide functionality on Shift + Escape
    document.addEventListener('keydown', hidePopupOnKey);

    // Add zoom functionality on wheel scroll with Shift key pressed
    popupDiv.addEventListener('wheel', zoomPopup);
    // Watch for changes to the DOM to attach hover events to newly added images
    const observer = new MutationObserver(() => {
        attachHoverEvents();
    });

    observer.observe(document.body, { childList: true, subtree: true });
})();
